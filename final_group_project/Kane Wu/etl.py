
import json
import pandas as pd
from glob import glob

def convert(x):
    ''' Convert a json string to a flat python dictionary
    which can be passed into Pandas. '''
    ob = json.loads(x)
    for k, v in ob.items():
        if isinstance(v, list):
            ob[k] = ','.join(v)
        elif isinstance(v, dict):
            for kk, vv in v.items():
                ob['%s_%s' % (k, kk)] = vv
            del ob[k]
    return ob


def convert2(x):
    ''' Convert a json string to a flat python dictionary
    which can be passed into Pandas. '''
    ob = json.loads(x)
    for k, v in ob.items():
        if isinstance(v, list):
            ob[k] = ','.join(str(v))
        elif isinstance(v, dict):
            for kk, vv in v.items():
                ob['%s_%s' % (k, kk)] = vv
            del ob[k]
    return ob

business = pd.DataFrame([convert(line) for line in file("yelp_academic_dataset_business.json")])
checkin = pd.DataFrame([convert(line) for line in file("yelp_academic_dataset_checkin.json")])
review = pd.DataFrame([convert(line) for line in file("yelp_academic_dataset_review.json")])
tip = pd.DataFrame([convert(line) for line in file("yelp_academic_dataset_tip.json")])
user = pd.DataFrame([convert2(line) for line in file("yelp_academic_dataset_user.json")])

cusine = ['Scottish', 'Mediterranean','Chinese','French','Italian', 'Thai',  'Indian', 'British', 'European', 'Greek', 'Nepalese', 'German', 'Turkish', 'Mexican', 'Pakistan', 'Seafood', 'Japanese', 'Vegetarian', 'Brazilian', 'American','Spanish','Bakeries', 'Gastropubs', 'Soup','Caterers','Cafes','Smoothies','Bistros','Pubs', 'Coffee & Tea','Burgers', 'Delis','Fast Food', 'Sandwiches', 'Pizza', 'Fish & Chips', 'Polish', 'African', 'Korean', 'Middle Eastern', 'Creperies', 'Brasseries','Chicken Wings'  ]

def cusineCategory(x):
    for cus in cusine:
        category = x.categories.encode('ascii','ignore')
        if cus in category:
            return cus

def getZip(x, name):
    start= x[name].find("EH")
    Zip = x[name][start:start + 4].replace(" ", "")
    return Zip
   

edinburgh = business[business.city == "Edinburgh"]
edinburgh = edinburgh[edinburgh['categories'].str.contains("Restaurants")]
edinburgh['cusine'] = edinburgh.apply(cusineCategory, axis = 1)
edinburgh['zip'] = edinburgh.apply(getZip,args=('full_address',),axis=1)
edinburgh = edinburgh[edinburgh.zip != "EH17"]
edinburghid = pd.DataFrame(edinburgh.business_id)
edinReview = pd.merge(edinburghid,review, how='left' ,on="business_id")
edinCheckin = pd.merge(edinburghid,checkin, how='left' ,on="business_id")
edinTip = pd.merge(edinburghid,tip, how='left' ,on="business_id")

edinUserIds = pd.concat([edinReview.user_id,edinTip.user_id])
uniqueIds = pd.DataFrame(edinUserIds.unique())
uniqueIds.columns = ['user_id']

edinUsers = pd.merge(uniqueIds,user, how = 'left' , on = 'user_id')

edinburgh.to_csv('edinburgh.csv', encoding = 'utf-8')
edinReview.to_csv('edinReview.csv', encoding = 'utf-8')
edinCheckin.to_csv('edinCheckin.csv', encoding = 'utf-8')
edinTip.to_csv('edinTip.csv',encoding = 'utf-8')
edinUsers.to_csv('edinUser.csv',encoding='utf-8')

#edinburgh = pd.read_csv('edinburgh.csv')

polling = pd.read_csv('polling.csv')
polling['zip'] = polling.apply(getZip,args=('POSTCODE',),axis=1)
polling = polling[['NEWWARD','zip']]
pollGroup = polling.groupby(['NEWWARD','zip']).size().sort_values(ascending=False)
pollGroup

wardsList = ['Almond' , 'Drum Brae Gyle' ,'Pentland Hills', 'Forth' , 'Forth.1', 'Inverleith' , 'Corstorphine Murrayfield' , 'Sighthill Gorgie' , 'Colinton Fairmilehead' , 'Fountainbridge Craiglockhart' , 'Meadows Morningside' , 'City Centre' ,'City Centre.1', 'Leith Walk' , 'Leith ' , 'Craigentinny Duddingston' , 'Southside Newington' ,'Southside Newington.1','Liberton Gilmerton' , 'Portobello Craigmillar']
wards = pd.read_csv('rawwards.csv')
wards['Forth.1'] = wards['Forth']
wards['Forth.1'][0] = "EH5"
wards['Forth.1'][1:17]= pd.to_numeric(wards['Forth'][1:17], errors='coerce')/2
wards['Forth'][1:17] = wards['Forth.1'][1:17]
wards['Southside Newington.1'] = wards['Southside Newington']
wards['Southside Newington.1'][0] = "EH9"
wards['Southside Newington.1'][1:17]= pd.to_numeric(wards['Southside Newington'][1:17], errors='coerce')/2
wards['Southside Newington'][1:17] = wards['Southside Newington'][1:17]
wards['City Centre.1'] = wards['City Centre']
wards['City Centre.1'][0] = "EH2"
wards['City Centre.1'][1:17]= pd.to_numeric(wards['City Centre'][1:17], errors='coerce')/2
wards['City Centre'][1:17] = wards['City Centre.1'][1:17]
wardsMelt = pd.melt(wards, id_vars=['Indicator'], value_vars=wardsList)


zipCode= ""
wardName = ""
wardsMelt['Zip'] = ""
for i, row in wardsMelt.iterrows():
    if row['Indicator'] == 'Zip':
        zipCode = row['value']
    wardsMelt['Zip'][i] = zipCode
    
wardsMelt = wardsMelt[wardsMelt.Indicator != 'Zip']
wardsMelt.columns = ['indicator','type','value','Zip']
wardsMelt[wardsMelt['type'] == 'City Centre']
wardsMelt.to_csv('edinPopulation.csv')

wardsMelt = pd.read_csv('edinPopulation.csv')

stats = ['All','Average annual household income','Average property value']

population = wardsMelt[wardsMelt.indicator == stats[0]]
population.value = pd.to_numeric(population.value)
populationGroup = population.groupby('Zip').value.sum()

income = wardsMelt[wardsMelt.indicator == stats[1]]
income.value = pd.to_numeric(income.value)
incomeGroup = income.groupby('Zip').value.sum()

propertyValue = wardsMelt[wardsMelt.indicator == stats[2]]
propertyValue.value = pd.to_numeric(propertyValue.value)
propertyGroup = propertyValue.groupby('Zip').value.sum()

restaurantGroup = edinburgh.groupby('zip').cusine.count()

    
hotels = pd.read_csv('edinHotels.csv')
hotels['zip'] = hotels.apply(getZip,args=('zip',),axis=1)

hotelsGroup = hotels.groupby('zip').address.count()

statistics = pd.concat([populationGroup/restaurantGroup,incomeGroup/restaurantGroup,propertyGroup/restaurantGroup, hotelsGroup/restaurantGroup,restaurantGroup],1)
statistics.columns = ['pop/rest','income/rest','property/rest','hotels/rest','Num of Rest']
statistics = statistics.dropna()

reviews = pd.read_csv('edinReview.csv')
edinReview = pd.merge(reviews,edinburgh, how='left' ,on="business_id")
reviewGroup = edinReview.groupby(['zip','business_id']).size()
reviewGrouped = reviewGroup.groupby(level=0)