## follow LD_Ne.sh
## usage: python Ne.py <.ld.gz file> <sample size>
## output to pwd

import numpy as np
import pandas
import sys
from scipy import stats

def main():
    filename = sys.argv[1] ## '.ld.gz' file, should be in 5 columns, header: <CHR> <POS1> <POS2> <R^2> <gdis>
    n = sys.argv[2] ## sample size
    n = int(n) * 2.0

    ld = pandas.read_csv(filename,sep='\s+',usecols=['R^2','gdis'])
    ld.dropna(inplace=True)

    res = pandas.DataFrame(columns=['lower','upper','#pairs','ave_dis','ave_r2','Ne','T(kya)'])
    res['lower'] = np.arange(10,250)/1000.0 ## genetic distance in range [0.01cM, 0.25cM]
    res['upper'] = res['lower']+0.001

    res['temp'] = res['lower'].apply(lambda x: ld[(ld['gdis']>=x) & (ld['gdis']<x+0.001)].copy())
    res['#pairs'] = res['temp'].apply(lambda x: x.shape[0])
    res['ave_dis'] = res['temp'].apply(lambda x: x['gdis'].mean())
    res['ave_r2'] = res['temp'].apply(lambda x: x['R^2'].mean())
    res.drop('temp',axis=1,inplace=True)

    res['Ne'] = 1.0/(4.0*res['ave_dis']/100.0)*(1.0/(res['ave_r2']-1.0/n)-2.0)
    res['T(kya)'] = 1.0/(2.0*res['ave_dis']/100.0)*25.0/1000.0

    res.to_csv(filename.split('.ld')[0]+'_Ne.txt',sep='\t',index=None)

    meanNE = stats.hmean(res['Ne'].values)
    with open(filename.split('.ld')[0]+'_Ne.hmean.txt','w') as f:
        f.write(str(meanNE)+'\n')

if __name__ == '__main__':
    main()

