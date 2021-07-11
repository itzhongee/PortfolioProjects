#!/usr/bin/env python
# coding: utf-8

# In[83]:


import pandas as pd
import matplotlib.pyplot as plt
plt.style.use('ggplot')
import seaborn as sns

get_ipython().run_line_magic('matplotlib.inline', '')
matplotlib.rcParams['figure.figsize']


# In[84]:


#Load the dataset and display the first 5 rows
df = pd.read_csv('D:/SMU/Data Analytics/Datasets/movies.csv')
df.head()


# In[85]:


#identify null values
df.isnull().sum()


# In[86]:


df.dtypes


# In[109]:


df.budget = df.budget.astype('int64')
df.gross = df.gross.astype('int64')
df.head()


# In[110]:


#create correct year column
df['yearcorrect'] = df.released.astype(str).str[:4]
df.head()


# In[89]:


df.sort_values(['gross'], inplace=False, ascending=True)


# In[90]:


pd.set_option('display.max_rows', None)


# In[91]:


#drop duplicate values
df.company.drop_duplicates().sort_values(ascending=False)


# In[92]:


del df['year']


# In[111]:


df.head()


# In[94]:


#Correlation between budget and gross revenue
#Plot scatterplot using matplotlib
plt.scatter(x=df['budget'],y=df['gross'])
plt.title('Budget vs Gross Earnings')
plt.xlabel('Budget')
plt.ylabel('Gross Earnings')
plt.show()


# In[95]:


#Plot budget vs gross using seaborn
sns.regplot(x='budget', y='gross', data=df, scatter_kws={'color': 'blue'}, line_kws={'color': 'yellow'})


# In[96]:


#correlation matrix
#different types of correlation: pearson, kendall, spearman
df.corr(method = 'pearson')
#High correlation betweenbudget and gross


# In[97]:


#plot correlation matrix
correlation_matrix = df.corr(method = 'pearson')
sns.heatmap(correlation_matrix, annot = True, xticklabels = correlation_matrix.columns, yticklabels = correlation_matrix.columns, cmap = "RdBu")
plt.title("Correlation Matrix for Movie Features")
plt.xlabel('Movie Features')
plt.ylabel('Movie Features')
plt.show()


# In[112]:


#Look at company
df.company.head()


# In[113]:


df_numerized = df

for col_name in df_numerized.columns:
    if(df_numerized[col_name].dtype == 'object'):
        df_numerized[col_name] = df_numerized[col_name].astype('category')
        df_numerized[col_name] = df_numerized[col_name].cat.codes
        
df_numerized.head()


# In[102]:


#plot correlation matrix
correlation_matrix = df_numerized.corr(method = 'pearson')
sns.heatmap(correlation_matrix, annot = True, xticklabels = correlation_matrix.columns, yticklabels = correlation_matrix.columns, cmap = "RdBu")
plt.title("Correlation Matrix for Movie Features")
plt.xlabel('Movie Features')
plt.ylabel('Movie Features')
plt.show()


# In[103]:


df_numerized.corr()


# In[104]:


correlation_mat = df_numerized.corr()
corr_pairs = correlation_mat.unstack()
corr_pairs


# In[106]:


sorted_pairs = corr_pairs.sort_values(ascending = False)
sorted_pairs


# In[108]:


high_correlation = sorted_pairs[(sorted_pairs) > 0.5]
high_correlation
#votes and budget have the highest correlation to gross earnings
#company had low correlation 


# In[ ]:




