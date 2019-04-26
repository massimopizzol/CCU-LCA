
# coding: utf-8

# # LCA of Carbon Capture and Use (CCU)

# _by Massimo Pizzol and Nils Thonemann (2019)_

# Initial set up

# In[1]:


import pandas as pd
import numpy as np
from lci_to_bw2 import *
from brightway2 import *
from matplotlib import pyplot as plt
import time
when = time.strftime("%Y%m%d")


# In[2]:


projects.set_current('CCU') # Carbon Capture and Use


# This below only if it's the first time you run this script

# In[ ]:


#bw2setup() # do this if its the first time only


# In[ ]:


#fpei34  = "/Users/massimo/Documents/AAU/Research/Databases/ecoinvent v3.4/datasets"
 
#if 'ecoinvent 3.4 conseq' in databases:
#     print("Database has already been imported")
#else:
#     ei34 = SingleOutputEcospold2Importer(fpei34, 'ecoinvent 3.4 conseq')
#     ei34.apply_strategies()
#     ei34.statistics()
 
#ei34.write_database()


# In[6]:


databases # List should include biosphere3, ecoinvent 3.4 conseq


# In[1]:


get_ipython().system('jupyter nbconvert --to script CCU_2018_working_version.ipynb # This to convert into .py file')


# ## Data import

# Import inventory data. Choose between _near term_ (nt) and _long term_ (lt) scenario.

# In[7]:


#Choose one of the two lines below
CCU_data = pd.read_csv('LCI_CCU_2018_nt_final.csv', header = 0, sep = ";", encoding = 'utf-8-sig') # important to specify encoding
#CCU_data = pd.read_csv('LCI_CCU_2018_lt_final.csv', header = 0, sep = ";", encoding = 'utf-8-sig') # important to specify encoding

# clean up 
CCU_data = CCU_data.drop(['OPENLCA names', 'Ecospold_code_OPENLCA'], 1)  # remove the columns not needed
CCU_data['Exchange uncertainty type'] = CCU_data['Exchange uncertainty type'].fillna(0).astype(int) # uncertainty as integer 
                    ### Note: (can't have the full column if there are mixed nan and values, so use zero as default)
print(CCU_data.head())
#print(CCU_data.tail())  
#print(CCU_data.iloc[:,6]) # no encoding problems



# In[8]:


# Create a dict that can be written as database
CCU_dict = lci_to_bw2(CCU_data) # Perfect.
CCU_dict


# In[9]:


# Write a bw2 database
databases
if 'CCU' in databases: del databases['CCU']
CCU = Database("CCU")
CCU.write(CCU_dict)
[print(act) for act in CCU]


# In[12]:


# Explore all activities:
for activity in Database("CCU"):
        print('--------ooo--------')
        print(activity['name'])
        print('--------ooo--------')
        for i in list(activity.exchanges()):  # Explore the activity
            print(i['type'])
            print(i)


# ## Static LCA

# Now do some calculations

# In[13]:


# The list of alternatives to be compared
acts = ['CO2_to_DME_SG [CO2_treatment]',
           'CO2_to_CO_DRM [CO2_treatment]',
           'CO2_to_DMM [CO2_treatment]' , 
           'CO2_to_DMC_eth_carb_trans [CO2_treatment]' ,
           'CO2_to_FA_hydro [CO2_treatment]' ,
           'CO2_to_DMC_elec [CO2_treatment]' ,
           'CO2_to_FA_elec_lp [CO2_treatment]' ,
           'CO2_to_EtOH_elec [CO2_treatment]' ,
           'CO2_to_MeOH [CO2_treatment]' ,
           'CO2_to_PEP [CO2_treatment]',
           'CO2_to_CO_rWGS [CO2_treatment]',
           'CO2_to_FT [CO2_treatment]',
           'CO2_to_CH4 [CO2_treatment]']


# In[14]:


# The list of impact categories to be used 
# list(methods) # (to see all possible ones)
ILCD = [('ILCD 1.0.8 2016 midpoint', 'climate change', 'GWP 100a'),
('ILCD 1.0.8 2016 midpoint', 'ecosystem quality', 'freshwater and terrestrial acidification'),
('ILCD 1.0.8 2016 midpoint', 'ecosystem quality', 'freshwater ecotoxicity'),
('ILCD 1.0.8 2016 midpoint','ecosystem quality','freshwater eutrophication'),
('ILCD 1.0.8 2016 midpoint', 'ecosystem quality', 'ionising radiation'),
('ILCD 1.0.8 2016 midpoint', 'ecosystem quality', 'marine eutrophication'),
('ILCD 1.0.8 2016 midpoint','ecosystem quality','terrestrial eutrophication'),
('ILCD 1.0.8 2016 midpoint', 'human health', 'carcinogenic effects'),
('ILCD 1.0.8 2016 midpoint', 'human health', 'ionising radiation'),
('ILCD 1.0.8 2016 midpoint', 'human health', 'non-carcinogenic effects'),
('ILCD 1.0.8 2016 midpoint', 'human health', 'ozone layer depletion'),
('ILCD 1.0.8 2016 midpoint', 'human health', 'photochemical ozone creation'),
('ILCD 1.0.8 2016 midpoint', 'human health', 'respiratory effects, inorganics'),
('ILCD 1.0.8 2016 midpoint', 'resources', 'land use'),
('ILCD 1.0.8 2016 midpoint', 'resources', 'mineral, fossils and renewables')]


# A little test for one activity only

# In[17]:


#mymethod = ('IPCC 2013', 'climate change', 'GWP 100a')
mymethod = ILCD[0]
print(mymethod)
acts[-4]
myact = Database('CCU').get(acts[-4])
print(myact)
functional_unit = {myact: 1} 
lca = LCA(functional_unit, mymethod)
lca.lci()
lca.lcia()
print(lca.score)


# Everything worked so now preparing for doing this **in loop** to all activities under analysis

# In[18]:


def dolcacalc(myact, mydemand, mymethod):
    my_fu = {myact: mydemand} 
    lca = LCA(my_fu, mymethod)
    lca.lci()
    lca.lcia()
    return lca.score

def getLCAresults(acts, mymethod):
    
    all_activities = []
    results = []
    for a in acts:
        act = Database('CCU').get(a)
        all_activities.append(act['name'])
        results.append(dolcacalc(act,1,mymethod)) # 1 stays for one unit of each process
        #print(act['name'])
     
    results_dict = dict(zip(all_activities, results))
    
    return results_dict


# Results with ILCD for all impact categories and all activities under analysis

# In[19]:


results_ILCD = []
for m in ILCD:
    results_all_acts = getLCAresults(acts,m) # total impact per tech
    results_ILCD.append(results_all_acts)


# Generate a nice output

# In[72]:


methods_names = []
for m in ILCD:
    m_name = ' '.join(m)
    methods_names.append(m_name)


# In[73]:


my_output = pd.DataFrame(results_ILCD, index=methods_names)
my_output.head()


# In[48]:


#Give a proper name to the file and export
my_output.to_csv('ILCD-results_nt.csv', sep = ';')
# my_output.to_csv('ILCD-results_lt.csv', sep = ';') # this is using long term scenario


# ## Uncertainty analysis (Monte Carlo simulation)

# In[74]:


mymethod = ILCD[0]
mymethod


# In[75]:


fus = [] # list of functional units
for a in acts:
    act = Database('CCU').get(a)
    functional_unit = {act: 1} # one unit of each process
    fus.append(functional_unit)


# In[76]:


mc = MonteCarloLCA(fus[0], mymethod) # important to initialize the MC simulation
next(mc)


# In[77]:


mc.redo_lcia(fus[0]) #just a test
print(mc.score)
mc.redo_lcia(fus[1])
print(mc.score)


# In[78]:


# Now the real simulation (takes time)
iterations = 1000
simulations = []

for _ in range(iterations):
    print(_)
    next(mc)
    mcresults = []    
    for i in fus:
        mc.redo_lcia(i)
        mcresults.append(mc.score)
    simulations.append(mcresults)
    

simulations


# In[79]:


df = pd.DataFrame(simulations, columns = acts)
df.to_csv('MCsimulation1000iter'+when+'_st.csv', sep = ';')
# df.to_csv('MCsimulation1000iter'+when+'_lt.csv', sep = ';') # This is using the long term data


# Give a look to the result

# In[80]:


df2 = df.drop(['CO2_to_DMC_elec [CO2_treatment]'], axis=1)


# In[81]:


df2.plot(kind = 'box')
plt.xticks(rotation=90)
#df.T.melt()
#plt.hist(df.Route30.values)
#df.Route20


# In[82]:


df.head()


# In[83]:


plt.hist(df['CO2_to_CO_rWGS [CO2_treatment]'].values)

