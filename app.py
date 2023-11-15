"""
This script imports necessary libraries for pygmtsar and sets display options for Pandas. 
It also prints a message indicating successful import of pygmtsar.
"""
import xarray as xr
import numpy as np
import pandas as pd
import geopandas as gpd
import json
import shapely
from dask.distributed import Client
import dask

# plotting modules
import pyvista as pv
# magic trick for white background
pv.set_plot_theme("document")
import panel
panel.extension('vtk')
import matplotlib.pyplot as plt
import matplotlib
from pygmtsar import S1, Stack, tqdm_dask, NCubeVTK, ASF

# define Pandas display settings
pd.set_option('display.max_rows', None)
pd.set_option('display.max_columns', None)
pd.set_option('display.width', None)
pd.set_option('display.max_colwidth', 100)

print('import pygmtsar successful..')