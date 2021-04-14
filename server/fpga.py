# Standard Library imports
import os, sys, threading, time, cv2, socket, binascii
# PyQt5 imports
from PyQt5 import QtWidgets, uic
from PyQt5.QtCore import QObject, pyqtSignal
SIM_FOLDER = os.path.dirname(__file__)
from PyQt5.QtGui import QImage, QPixmap
from threading import Condition, Thread

COMPUTE_PORT = 6063
VGA_PORT = 6060
IMAGE_DIM_VIDEO = 32
IMAGE_DIM_DDR = 180

classification = -1

import numpy as np
from datetime import datetime 

import torch
import torch.nn as nn
import torch.nn.functional as F
from torch.utils.data import TensorDataset, DataLoader

import pandas as pd

class SignalsToGui(QObject):
    trigger_console = pyqtSignal(str)
    trigger_send_vga_res = pyqtSignal(str)
    compute_active = False
    vga_active = False

    def __init__(self):
        super().__init__()

    def connect_to_slot(self, slot):
        self.trigger.connect(slot)

class SignalsFromGui:
    trigger_compute = Condition()
    trigger_vga = Condition()
    desl_ip = None
    img_path = 0
    type = None

# Same as frame2hex except this function doesn't read in frames
def img2hex(image, board):
    if board == "video":
        image = cv2.resize(image, (IMAGE_DIM_VIDEO, IMAGE_DIM_VIDEO))
    elif board == "ddr":
        image = cv2.resize(image, (IMAGE_DIM_DDR, IMAGE_DIM_DDR))
    image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    return binascii.hexlify(bytearray(image))

def ComputeServer(connection, address, sigs_to_gui, sigs_from_gui):
    while sigs_to_gui.compute_active:
        with sigs_from_gui.trigger_compute:
            sigs_from_gui.trigger_compute.wait()
            if sigs_from_gui.type == "Image":
                img = cv2.imread(sigs_from_gui.img_path)
                hex_img = img2hex(img, "video")
                sigs_to_gui.trigger_console.emit(f'Starting to send image to the compute client.')
                start = time.time_ns()
                len_data = len(hex_img)
                packet_size = 64
                left_index = 0
                right_index = packet_size
                while(len_data - left_index > packet_size):
                    connection.sendall(hex_img[left_index:right_index])
                    left_index = right_index
                    right_index += packet_size
                # Send the last packet, which will be left index to the end
                connection.sendall(hex_img[left_index:])

                data = connection.recv(1024)
                sigs_to_gui.trigger_console.emit(f'Successfully sent the image to compute client in: {time.time_ns() - start}ns.')

                # When the neural core finishes computation, sends result
                data = connection.recv(1024)
                sigs_to_gui.trigger_console.emit(f'Received signal indicating neural core is done processing.')
				classification = data
                # Now send a signal to the gui that tells it to send a message to the VGA server
                sigs_to_gui.trigger_send_vga_res.emit('')

            elif sigs_from_gui.type == "Close":
                # Close the connection if break from loop
                connection.shutdown(1)
                connection.close()
                sigs_to_gui.compute_active = False


def VgaServer(connection, address, sigs_to_gui, sigs_from_gui):
    while sigs_to_gui.vga_active:
        with sigs_from_gui.trigger_vga:
            sigs_from_gui.trigger_vga.wait()
            if sigs_from_gui.type == "Image":
                img = cv2.imread(sigs_from_gui.img_path)
                hex_img = img2hex(img, "ddr")
                sigs_to_gui.trigger_console.emit(f'Starting to send image to the vga client.')
                start = time.time_ns()
                len_data = len(hex_img)
                packet_size = 64
                left_index = 0
                right_index = packet_size
                while(len_data - left_index > packet_size):
                    #print(hex_img[left_index:right_index])
                    connection.sendall(hex_img[left_index:right_index])
                    left_index = right_index
                    right_index += packet_size
                # Send the last packet, which will be left index to the end
                connection.sendall(hex_img[left_index:])

                data = connection.recv(1024)
                sigs_to_gui.trigger_console.emit(f'Successfully sent the image to vga client in: {time.time_ns() - start}ns.')
            
            elif sigs_from_gui.type == "Classify":
                connection.sendall(str(classification).encode())
                # sigs_to_gui.trigger_console.emit(f'Sent classification to VGA board.')

            elif sigs_from_gui.type == "Close":
                # Close the connection if break from loop
                connection.shutdown(1)
                connection.close()
                sigs_to_gui.vga_active = False

class Backend():
    def __init__(self, sigs_to_gui, sigs_from_gui):
        self.sigs_to_gui = sigs_to_gui
        self.sigs_from_gui = sigs_from_gui


    def startCompute(self):
        # Setup the socket
        connection = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        connection.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

        # Bind to an address and port to listen on
        try:
            connection.bind((self.sigs_from_gui.desl_ip, COMPUTE_PORT))
            connection.listen(10)
            print("Server opened on ",self.sigs_from_gui.desl_ip," port ", COMPUTE_PORT)
            self.sigs_to_gui.trigger_console.emit(f'Compute server opened on: {self.sigs_from_gui.desl_ip}')
        except Exception:
            self.sigs_to_gui.trigger_console.emit(f'Failed to open compute server on the given IP address.')
            return

        # We only need one connection so no while loop needed
        # If we need more connection can add a loop here
        new_conn, new_addr = connection.accept()
        self.sigs_to_gui.trigger_console.emit(f'Compute server has successfully connected to the client')
        self.sigs_to_gui.compute_active = True
        Thread(target=ComputeServer, args=(new_conn, new_addr, self.sigs_to_gui, self.sigs_from_gui)).start()

    def startVGA(self):
        # Setup the socket
        connection = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        connection.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

        # Bind to an address and port to listen on
        try:
            connection.bind((self.sigs_from_gui.desl_ip, VGA_PORT))
            connection.listen(10)
            print("Server opened on ",self.sigs_from_gui.desl_ip," port ", VGA_PORT)
            self.sigs_to_gui.trigger_console.emit(f'VGA server opened on: {self.sigs_from_gui.desl_ip}')
        except Exception as exc:
            print(exc)
            self.sigs_to_gui.trigger_console.emit(f'Failed to open vga server on the given IP address.')
            return

        # We only need one connection so no while loop needed
        # If we need more connection can add a loop here
        new_conn, new_addr = connection.accept()
        self.sigs_to_gui.trigger_console.emit(f'VGA server has successfully connected to the client')
        self.sigs_to_gui.vga_active = True
        Thread(target=VgaServer, args=(new_conn, new_addr, self.sigs_to_gui, self.sigs_from_gui)).start()

def main():
    """ 
    The main function that initiates the backend server, and creates the GUI,
    which runs on the main server. Signals between GUI and the backend are created
    and passed to both. 
    """
    sigs_to_gui = SignalsToGui()
    sigs_from_gui = SignalsFromGui()

    backend = Backend(sigs_to_gui, sigs_from_gui)
    os.environ["QT_STYLE_OVERRIDE"] = ""
    app = QtWidgets.QApplication(sys.argv)
    fpga_ui = FpgaUi(sigs_to_gui, sigs_from_gui, backend)
    sigs_to_gui.trigger_console.connect(fpga_ui.update_console)
    sigs_to_gui.trigger_send_vga_res.connect(fpga_ui.send_class)
    
    fpga_ui.show()
    sys.exit(app.exec_())

class FpgaUi(QtWidgets.QMainWindow):
    """ 
    This class inherits from QMainWindow and loads the file found in fpga_ui.ui.
    It has functions defined in the slots in Main_Window.ui. The backend script starts
    when this class is initialized. Images are loaded when the class is initialized
    and sizing features which cannot be done through QtDesigner are completed here.

    Args:
        to_gui (SigsToGui): Signals sent from other threads to the GUI thread.
    Attributes:
        sigs_to_gui: Signals sent from other threads to the GUI thread.
    """
    def __init__(self, sigs_to_gui, sigs_from_gui, backend):
        super().__init__()

        uic.loadUi(r"./fpga_gui.ui",self)
        self.backend = backend
        self.sigs_to_gui = sigs_to_gui
        self.sigs_from_gui = sigs_from_gui
        #hostname = socket.gethostname()
        #ip_address = socket.gethostbyname(hostname)
        ip_address = '1.1.X.1'
        self.lineEdit_computation.setText(str(ip_address))


    def closeEvent(self, event):
        """
        This function gracefully closes stops the backend when the GUI
        closes. 
        """
        with self.sigs_from_gui.trigger_compute:
            self.sigs_from_gui.type = "Close"
            self.sigs_from_gui.trigger_compute.notify()

        with self.sigs_from_gui.trigger_vga:
            self.sigs_from_gui.type = "Close"
            self.sigs_from_gui.trigger_vga.notify()

    def clickedStop(self, event):
        if(self.pushButton_stop.text() == "Stop"):
            self.sigs_from_gui.run_webcam = False
            self.pushButton_stop.setText("Start")
        else:
            self.sigs_from_gui.run_webcam = True
            self.backend_thread = threading.Thread(target=self.backend.startVideo)
            self.backend_thread.start()
            self.pushButton_stop.setText("Stop")

    def clickedComputation(self, event):
        self.sigs_from_gui.desl_ip = self.lineEdit_computation.text()

        if(self.pushButton_computation_start.text() == "Start"):
            backend_thread = threading.Thread(target=self.backend.startCompute)
            backend_thread.start()
            self.pushButton_computation_start.setText("Stop")

        elif (self.pushButton_computation_start.text() == "Stop"):
            self.sigs_from_gui.type = "Close"
            with self.sigs_from_gui.trigger_compute:
                self.sigs_from_gui.trigger_compute.notify()
            self.pushButton_computation_start.setText("Start")

    def clickedVGA(self, event):
        self.sigs_from_gui.desl_ip = self.lineEdit_computation.text()
        print(self.sigs_from_gui.desl_ip)
        if(self.pushButton_vga_start.text() == "Start"):
            backend_thread = threading.Thread(target=self.backend.startVGA)
            backend_thread.start()
            self.pushButton_vga_start.setText("Stop")

        elif (self.pushButton_vga_start.text() == "Stop"):
            self.sigs_from_gui.type = "Close"
            with self.sigs_from_gui.trigger_vga:
                self.sigs_from_gui.trigger_vga.notify()
            self.pushButton_vga_start.setText("Start")

    # Send image to compute server first and then the VGA. Set the image path here.
    def clickedSend(self, event):
        self.sigs_from_gui.img_path = self.lineEdit_image.text()
        with self.sigs_from_gui.trigger_compute:
            self.sigs_from_gui.type = "Image"
            self.sigs_from_gui.trigger_compute.notify()
        with self.sigs_from_gui.trigger_vga:
            self.sigs_from_gui.type = "Image"
            self.sigs_from_gui.trigger_vga.notify()

    def clickedBrowse(self, event):
        file_selected = QtWidgets.QFileDialog.getOpenFileName(parent=self)
        if file_selected[0]:
             self.lineEdit_image.setText(file_selected[0])

        image = QPixmap(file_selected[0])
        self.image.setPixmap(image)
        self.image.setScaledContents(True)

    def clickedClear(self, event):
        self.plainTextEdit_console.clear()

    def updateImage(self, outImage):
        self.cameraOutput.setPixmap(QPixmap.fromImage(outImage))
        self.cameraOutput.setScaledContents(True)

    def update_console(self, console_message):
        """
        Prints the message to the console.
        Args:
            console_message (str): Message to be printed in terminal.
        """
        self.plainTextEdit_console.appendPlainText(console_message)

    def send_class(self, sig):
        self.sigs_from_gui.type = "Classify"
        with self.sigs_from_gui.trigger_vga:
            self.sigs_from_gui.trigger_vga.notify()

if __name__ == "__main__":
    main()

