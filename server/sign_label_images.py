import pandas as pd
from PIL import Image, ImageDraw, ImageFont

keepcharacters = (' ','.','_')
W, H = 500, 30

sign_names = pd.read_csv("signnames.csv")

def save_label_images(sign_names):
    for sign_name in sign_names.SignName:
        sign_name = "".join(c for c in sign_name if c.isalnum() or c in keepcharacters).rstrip()
        img = Image.new('L', (W, H))
        d = ImageDraw.Draw(img)
        w, h = d.textsize(sign_name)
        d.text(((W-w)/2,(H-h)/2), sign_name, fill="white")
        
        img.save('./sign_labels/' + sign_name + '.png')