# launch SDK with specified hardware target
set proj_dir W:/ece532
set design_dir $proj_dir/final_demo/new_bitstream/final_demo/lenet/lenet
set sdk_dir $design_dir/lenet.sdk
set hw_hdf_file $sdk_dir/lenet_wrapper.hdf

open_project $design_dir/lenet.xpr
launch_sdk -workspace $sdk_dir -hwspec $hw_hdf_file
