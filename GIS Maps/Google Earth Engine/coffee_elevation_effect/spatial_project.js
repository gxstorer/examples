{\rtf1\ansi\ansicpg1252\cocoartf2639
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 //////////////////////////////////////////////\
//                Get Data                  //\
//////////////////////////////////////////////\
\
// Region: Tseltal Mayan Coffee Villages (Chiapas, Mexico)\
var point           =   ee.Geometry.Point([-92.14120700691065 , 17.08470363718753]);\
Map.centerObject  (point, 11);\
\
// Parcel shapefile of coffee farms\
var parcels         =   ee.FeatureCollection("projects/envm-677-gxstorer/assets/chiapas_parcels");\
\
// get the MODIS pre-computed daily rainfall product\
var modis_rainfall  =   ee.ImageCollection("UCSB-CHG/CHIRPS/DAILY") \
                        .filterDate('2015-01-01', '2016-12-31')\
                        .filterBounds(point)\
\
// Landsat 8\
var landsat8        =   ee.ImageCollection('LANDSAT/LC08/C02/T1_L2')\
                        .filterDate('2015-01-01', '2016-12-31')\
                        .filterBounds(point)\
                        .select\
(\
            ['SR_B2', 'SR_B3', 'SR_B4', 'SR_B5' , 'SR_B6', 'SR_B7'],\
            ['blue' , 'green', 'red'  , 'nir'   , 'swir1', 'swir2']\
);\
\
//////////////////////////////////////////////\
//                Get Images                //\
//////////////////////////////////////////////\
\
// Elevation & Hillshade Image\
var srtm            =   ee.Image("USGS/SRTMGL1_003")\
var hillshade       =   ee.Terrain.hillshade(srtm);\
\
/* \
Previous studies have shown that images should not be more\
than one year apart because the forest degradation disturbance\
quickly disappears with tree foliage and understory vegetation growth.\
Changes in NDFI are a good indicator of forest change.\
*/\
\
var chiapasPre    =   landsat8\
                      .filterDate('2015-09-01', '2015-12-31')\
                      .sort('CLOUD_COVER', true)\
                      .first()\
                      .multiply(0.0000275)\
                      .add(-0.2);\
\
var chiapasPost   =   landsat8\
                      .filterDate('2016-09-01', '2016-12-31')\
                      .sort('CLOUD_COVER', true)\
                      .first()\
                      .multiply(0.0000275)\
                      .add(-0.2);\
\
var preImage      =   landsat8\
                      .filterBounds(point)\
                      .filterDate('2015-09-01', '2015-12-31')\
                      .sort('CLOUD_COVER', false)\
                      .first();\
    \
var postImage     =   landsat8\
                      .filterBounds(point)\
                      .filterDate('2016-09-01', '2016-12-31')\
                      .sort('CLOUD_COVER', false)\
                      .first();  \
\
// Image parameters\
var imageVis  = \
\{\
            'opacity' : 1,\
            'bands'   : ['swir1', 'nir', 'red'],\
            'min'     : 0,\
            'max'     : 0.4,\
            'gamma'   : 1\
\};\
\
//////////////////////////////////////////////\
//  Create spectral mixture analysis (SMA)  //\
//////////////////////////////////////////////\
\
\
// create fraction endmembers\
var   endmembers  = \
[\
      [0.0119,  0.0475,  0.0169,  0.625 , 0.2399, 0.0675], // Green Vegetation (GV)\
      [0.1514,  0.1597,  0.1421,  0.3053, 0.7707, 0.1975], // Non-Photosynthetic Vegetation (NPV)\
      [0.1799,  0.2479,  0.3158,  0.5437, 0.7707, 0.6646], // Soil\
      [0.4031,  0.8714,  0.79  ,  0.8989, 0.7002, 0.6607]  // Cloud\
];\
\
// Create fractions function\
var   getSMAFractions   =   function(chiapasPre, endmembers) \
\{\
    var unmixed = ee.Image(chiapasPre)\
        .select([0, 1, 2, 3, 4, 5 ]) \
        .unmix(endmembers)\
        .max(0) \
        .rename('GV', 'NPV', 'Soil', 'Cloud');\
    return ee.Image (unmixed.copyProperties(chiapasPre));\
\};\
\
// SMA parameters\
var   fractionVis   = \
\{\
                'opacity': 1,\
                'min': 0.0,\
                'max': 0.5\
\};\
\
// Pre and Post variables\
var smaPre    =   getSMAFractions (chiapasPre  , endmembers);\
var smaPost   =   getSMAFractions (chiapasPost , endmembers);\
\
// Add SMA bands\
var Shade     =   smaPre.reduce(ee.Reducer.sum())\
                        .subtract(1.0)\
                        .abs()\
                        .rename('Shade');\
\
var GVs       =   smaPre.select('GV')\
                        .divide(Shade.subtract(1.0).abs())\
                        .rename('GVs');\
\
smaPre        =   smaPre.addBands([Shade, GVs]);\
\
/////////////////////////////////////////////////////////\
//  Create Normalized Difference Fraction Index (NDFI) //\
/////////////////////////////////////////////////////////\
\
function getNDFI(smaImage) \
\{\
    var Shade   = smaImage.reduce(ee.Reducer.sum())\
                          .subtract(1.0)\
                          .abs()\
                          .rename('Shade');\
    var GVs     = smaImage.select('GV')\
                          .divide(Shade.subtract(1.0).abs())\
                          .rename('GVs');\
  smaImage      = smaImage.addBands([Shade, GVs]);\
  \
    var ndfi    = smaImage.expression('(GVs - (NPV + Soil))  / (GVs + NPV + Soil)', \
      \{\
            'GVs' : smaImage.select('GVs'),\
            'NPV' : smaImage.select('NPV'),\
            'Soil': smaImage.select('Soil')\
      \}\
    ).rename('NDFI');\
  return ndfi;\
\}\
\
// Color palette\
var palettes    =   require('projects/gee-edu/book:Part A - Applications/A3 - Terrestrial Applications/A3.4 Forest Degradation and Deforestation/modules/palettes');\
var ndfiColors  =   palettes.ndfiColors;\
\
// Parameters\
var ndfiVis     =\
\{\
          bands   : ['NDFI'],\
          min     : -1,\
          max     : 1,\
          palette : ndfiColors\
\};\
\
// Create water & cloud masks\
var getWaterMask  =   function(smaPre) \
\{\
    var waterMask = (smaPre.select('Shade').gte(0.65))\
          .and(smaPre.select('GV')         .lte(0.15))\
          .and(smaPre.select('Soil')       .lte(0.05));\
    return  waterMask.rename('Water');\
\};\
\
var cloud           =   smaPre.select('Cloud').gte(0.1);\
var water           =   getWaterMask(smaPre);\
var cloudWaterMask  =   cloud.max(water);\
\
// Pre and Post variables\
var ndfiPre         =   getNDFI(smaPre);\
var ndfiPost        =   getNDFI(smaPost);\
\
/////////////////////////////////////////////////////////\
//                  Change Analysis                    //\
/////////////////////////////////////////////////////////\
\
var ndfi        =   ndfiPre.select('NDFI')\
                            .addBands(ndfiPost.select('NDFI'))\
                            .rename('NDFI_Pre', 'NDFI_Post');\
\
// Calculate the NDFI change.\
var ndfiChange  =   ndfi.select('NDFI_Post')\
                        .subtract(ndfi.select('NDFI_Pre'))\
                        .rename('NDFI Change');\
\
// Create a Classification layer of NDFI difference.\
var changeClassification  =   ndfiChange.expression(\
    '(b(0) >= -0.095 && b(0) <= 0.095) ? 1 :' +     //  No forest change\
    '(b(0) >= -0.250 && b(0) <= -0.095) ? 2 :' +    // Logging\
    '(b(0) <= -0.250) ? 3 :' +                      // Deforestation\
    '(b(0) >= 0.095) ? 4  : 0')                     // Vegetation regrowth\
  .updateMask(ndfi.select('NDFI_Pre')\
  .gt(0.60)                                         // mask out no forest\
);                    \
\
// Create threshold for forest\
var forest  =   ndfi.select('NDFI_Pre').gt(0.60);\
\
/////////////////////////////////////////////////////////\
//                    Using NBR                        //\
/////////////////////////////////////////////////////////\
\
var nbrPre        =   preImage.normalizedDifference(['nir', 'swir2'])\
                              .rename('nbr_pre');\
var nbrPost       =   postImage.normalizedDifference(['nir', 'swir2'])\
                              .rename('nbr_post');\
    \
// 2-date change.\
var diff          =   nbrPost.subtract(nbrPre)\
                              .rename('change');\
\
var nbrPalette    = \
[\
              '011959', '0E365E', '1D5561', '3E6C55', '687B3E',\
              '9B882E', 'D59448', 'F9A380', 'FDB7BD', 'FACCFA'\
];\
var visParams     = \
\{\
              palette : nbrPalette,\
              min     : -0.2,\
              max     : 0.2\
\};\
\
// Classify change \
var thresholdGain     =     0.2;\
var thresholdLoss     =    -0.2;\
\
var diffClassified    =     ee.Image(0);\
\
diffClassified        =     diffClassified.where(diff.lte(thresholdLoss), 2);\
diffClassified        =     diffClassified.where(diff.gte(thresholdGain), 1);\
\
var changeVis         = \
\{\
            opacity : 0.75,\
            palette : ['white','blue','red'],\
            min     : 0,\
            max     : 2\
\};\
\
/////////////////////////////////////////////////////////\
//                    Using NDVI                       //\
/////////////////////////////////////////////////////////\
\
var ndviPre         =   chiapasPre.normalizedDifference(['nir', 'red'])\
                                  .rename('ndvi_pre');\
                      \
\
var ndviPost        =   chiapasPost.normalizedDifference(['nir', 'red'])\
                                  .rename('ndvi_post');\
                        \
\
var vegPalette      =   ['red', 'white', 'green'];\
\
var ndviVisPar      = \
\{\
              palette : vegPalette,\
              min     : -1,\
              max     : 1\
\};\
\
var ndviDiff            =   ndviPost.subtract(ndviPre).rename('NDVI change');\
var ndviDiffClassified  =   ee.Image(0);\
\
ndviDiffClassified      =   ndviDiffClassified.where(ndviDiff.lte(thresholdLoss), 2);\
ndviDiffClassified      =   ndviDiffClassified.where(ndviDiff.gte(thresholdGain), 1);\
\
var imageWithViz        =   ndviDiffClassified.visualize(visParams);\
var projection          =   imageWithViz.projection().getInfo();\
\
/////////////////////////////////////// \
//       Print to Console            //\
///////////////////////////////////////\
\
print   (srtm,                'elevation');\
print   (landsat8,            'landsat');\
print   (chiapasPre,          'pre image');\
print   (smaPre,              'SMA');\
print   (ndviDiff,            'ndvi change');\
print   (ndviDiffClassified,  'ndvi change by 20%');\
print   (projection,          'crs')\
print   (modis_rainfall,      'rainfall')\
\
/////////////////////////////////////// \
//          Map Layers               //\
///////////////////////////////////////\
\
Map.addLayer(srtm , \
\{\
                                  min     : 0, \
                                  max     : 1500,\
                                  palette : ['blue', 'yellow', 'green']\
\},        \
                                  'Meters above sea level');\
\
Map.addLayer(hillshade  , \
\{\
                                  opacity : .3,\
                                  min     : 150, \
                                  max     :255\
\},          \
                                  'Hillshade');\
\
Map.addLayer(chiapasPre           , imageVis  , 'Landsat 8 RGB pre'   , false);\
Map.addLayer(chiapasPost          , imageVis  , 'Landsat 8 RGB post'  , false);\
Map.addLayer(ndfiPre              , ndfiVis   , 'NDFI pre'            , false);\
Map.addLayer(ndfiPost             , ndfiVis   , 'NDFI Post'           , false);\
\
Map.addLayer(cloudWaterMask.selfMask(),\
\{\
                                  min     : 1,\
                                  max     : 1,\
                                  palette : 'blue'\
\},\
                                  'Cloud and water mask'              , false);\
Map.addLayer(ndfi , \
                                  \{'bands': ['NDFI_Pre', 'NDFI_Post', 'NDFI_Post']\} , \
                                  'NDFI Change'                       , false);\
Map.addLayer(ndfiChange ,\
                                  \{\}  , 'NDFI Difference'             , false);\
Map.addLayer(changeClassification, \
                                  \{palette: ['000000', '1eaf0c', 'ffc239', 'ff422f', '74fff9']\},\
                                  'Change Classification'             , false);\
Map.addLayer(diff                 , visParams  , 'NBR change'         , false);\
Map.addLayer(diffClassified.selfMask(),\
                                  changeVis, 'NBR change classified by threshold', false);\
                \
Map.addLayer(ndviPre              , ndviVisPar, 'NDVI pre'            ,  false);\
Map.addLayer(ndviPost             , ndviVisPar, 'NDVI post'           ,  false);\
Map.addLayer(ndviDiff             , visParams , 'NDVI change'         ,  false);\
\
Map.addLayer(ndviDiffClassified.selfMask(), \
                                changeVis, 'NDVI change classified by threshold', true);\
Map.addLayer(parcels);\
\
}