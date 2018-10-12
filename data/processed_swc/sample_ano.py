import os
mydir = "Axon/"
swc_list = [swc for swc in sorted(os.listdir(mydir)) if swc.endswith("distal_axon.cropped.swc")]
for i,swc in enumerate(swc_list):
    if (swc.startswith("17302") & (i % 4 == 0)):
        print("SWCFILE=Axon/"+swc)
