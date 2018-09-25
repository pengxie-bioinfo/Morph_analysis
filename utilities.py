import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA, RandomizedPCA
from sklearn.preprocessing import scale
from sklearn.manifold import Isomap, TSNE
from sklearn.cluster import KMeans


def load_features(file_names, drop_attr=[]):
    df_list = []
    for file in file_names:
        df = pd.read_csv(file, index_col=[0], header=[0], delimiter="\t", skiprows=[1]).transpose()
        df = df.iloc[:, 6:]
        df = df.drop(drop_attr, axis=1)
        df = df.dropna(axis=1, how='all')
        df = df.dropna(axis=0, how='any')
        df_list.append(df)
    return (df_list)

def load_features_as_one(file_names, drop_attr=[]):
    df_combined = None
    for file in file_names:
        df = pd.read_csv(file, index_col=[0], header=[0], delimiter="\t").transpose()
        if df_combined is None:
            df_combined = df
        else:
            df_combined = pd.concat([df_combined, df])
    drop_attr = drop_attr+['N_node ', 'Soma_surface ', 'N_stem ', 'f0 ', 'f1 ', 'f2 ']
    drop_attr = list(set(drop_attr))
    drop_attr = [i for i in drop_attr if i in df_combined.columns.tolist()]
    df_combined = df_combined.drop(drop_attr, axis=1)
    df_combined = df_combined.dropna(axis=1, how='all') # drop if a feature is all NA
    df_combined = df_combined.dropna(axis=0, how='any') # drop if a sample has any NA
    for i in range(1, df_combined.shape[1]):
        df_combined.iloc[:,i] = pd.to_numeric(df_combined.iloc[:,i])
    return (df_combined)


def load_qc(file_names):
    df_list = []
    for file in file_names:
        qc = pd.read_csv(file_names, delimiter="\t", index_col=0)
        qc_names = qc.columns.tolist()
        qc_numbers = [p2f(qc.iloc[1, i]) for i in range(qc.shape[1])]
        qc = dict(zip(qc_names, qc_numbers))
        df_list.append(qc)
    return(df_list)


def feature_hist(df, ncol=4, len_single_plot=5):
    n = df.shape[1]
    if ((n % ncol) == 0):
        nrow = int(n / ncol)
    else:
        nrow = int(n / ncol + 1)

    print(nrow, ncol)
    fig, ax = plt.subplots(nrow, ncol, figsize=(len_single_plot * ncol, len_single_plot * nrow))
    ax = ax.reshape(-1, )
    for i in range(n):
        ax[i].hist(df.iloc[:, i], label=df.columns[i])
        ax[i].legend()
    return


def feature_hist_compare(df_list, df_names, ncol=4, len_single_plot=5):
    n = df_list[0].shape[1]
    featuer_names = df_list[0].columns.tolist()
    assert all([df.shape[1] == n for df in df_list])
    assert len(df_list) == len(df_names)
    if ((n % ncol) == 0):
        nrow = int(n / ncol)
    else:
        nrow = int(n / ncol + 1)

    print(nrow, ncol)
    fig, ax = plt.subplots(nrow, ncol, figsize=(len_single_plot * ncol, len_single_plot * nrow))
    ax = ax.reshape(-1, )
    for i in range(n):
        ax[i].set_title(featuer_names[i])
        for j in range(len(df_list)):
            df = df_list[j]
            ax[i].hist(df.iloc[:, i], histtype='step', normed=True, label=df_names[j])
        ax[i].legend()
    return

def p2f(x):
    return float(x.strip('%'))/100