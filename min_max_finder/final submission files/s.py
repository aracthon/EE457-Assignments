import seaborn
import numpy as numpy
import pandas as pd
import matplotlib.pyplot as plt


plt.figure(1, figsize = (8.5,11))
salary = {'SH':2000, 'OTHER':2500}
ylim = [1900, 2600]

df = pd.DataFrame({'SH':2000, 
				'OTHER':2500})

df.plot(kind='bar')
