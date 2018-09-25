import numpy as np
import pandas as pd

import matplotlib
if matplotlib.get_backend() == "MacOSX":
    matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import time

def move_figure(f, x, y):
    """Move figure's upper left corner to pixel (x, y)"""
    backend = matplotlib.get_backend()
    if backend == 'TkAgg':
        f.canvas.manager.window.wm_geometry("+%d+%d" % (x, y))
    elif backend == 'WXAgg':
        f.canvas.manager.window.SetPosition((x, y))
    else:
        # This works for QT and GTK
        # You can also use window.setGeometry
        f.canvas.manager.window.move(x, y)
    return(f)

def load_data(data, last_n=9):
    qc = pd.read_csv(data, sep="\t", index_col=[0])
    if(len(qc)>last_n):
        qc = qc.iloc[(len(qc)-9):, :]
    qc = qc.sort_values(['Type', 'Percentage_unconnected(%)'])
    celltypes = qc['Type'].tolist()
    ydata = qc['Percentage_unconnected(%)'].tolist()
    ydata = np.array(ydata)
    sampleid = qc.index.tolist()
    return([ydata, celltypes, sampleid])

def whether_changed(old, new):
    if len(old) != len(new):
        return False
    ct = 0
    for i in range(len(old)):
        if(old[i] != new[i]):
            ct = ct + 1
    return (ct==0)

def barplot(ydata, celltypes, sampleid):
    # colors
    u_celltypes = sorted(list(set(celltypes)))
    my_pal = ['C'+str(i) for i in range(len(u_celltypes))]
    lut = dict(zip(sorted(u_celltypes), my_pal))
    colors = []
    for tp in celltypes:
        colors.append(lut[tp])

    # plot
    fig, ax = plt.subplots(figsize=(18,10))
    fig = move_figure(fig, 450, 500)
    cur_x = 0
    for tp in u_celltypes:
        lab = [i for i,j in enumerate(celltypes) if j==tp]
        ax.bar(cur_x+np.arange(len(lab)), ydata[lab], color=lut[tp], label=tp)
        cur_x = cur_x+len(lab)
    plt.xticks(np.arange(len(sampleid)), sampleid, rotation=45)
    plt.xlabel("Samples")
    plt.ylabel("Percentage_unconnected(%)")
    plt.yscale("log", nonposy='clip')
    plt.legend(loc='upper left')
    return

def main():
    ct = 0
    ydata = np.array([])
    celltypes = []
    sampleid = []
    while True:
        if(ct>0):
            plt.close()
        ct = ct + 1
        ydata_new, celltypes_new, sampleid_new = load_data(data="/Users/pengxie/Documents/Morph_analysis/data/test/QC.csv")
        # Check whether data have changed:
        check1 = whether_changed(ydata, ydata_new)
        check2 = whether_changed(celltypes, celltypes_new)
        check3 = whether_changed(sampleid, sampleid_new)
        if not (check1 & check2):
            ydata = ydata_new
            celltypes = celltypes_new
            sampleid = sampleid_new
            barplot(ydata, celltypes, sampleid)
            plt.draw()
            plt.pause(1e-17)
        time.sleep(10)
    plt.show()
    return

if __name__ == "__main__":
    main()
