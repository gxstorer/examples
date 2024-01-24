{\rtf1\ansi\ansicpg1252\cocoartf2639
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fnil\fcharset0 Menlo-Bold;\f1\fnil\fcharset0 Menlo-Regular;}
{\colortbl;\red255\green255\blue255;\red25\green25\blue25;\red255\green255\blue255;\red102\green0\blue145;
\red50\green133\blue2;\red57\green112\blue235;}
{\*\expandedcolortbl;;\cssrgb\c12941\c12941\c12941;\cssrgb\c100000\c100000\c100000;\cssrgb\c48235\c12157\c63529;
\cssrgb\c23922\c58039\c0;\cssrgb\c28235\c53333\c93725;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\partightenfactor0

\f0\b\fs28 \cf2 \cb3 \expnd0\expndtw0\kerning0
var
\f1\b0  \cf4 regions\cf2  
\f0\b =
\f1\b0  \cf5 /* color: #cfd620 */\cf2  \cf5 /* shown: false */\cf2  
\f0\b \cf4 ee.Geometry.Polygon
\f1\b0 \cf2 ( [[[\cf6 -92.63706425282713\cf2 , \cf6 17.336916060543743\cf2 ], [\cf6 -92.22913173976742\cf2 , \cf6 16.67759612565251\cf2 ], [\cf6 -91.59049290809135\cf2 , \cf6 16.98258653851672\cf2 ], [\cf6 -92.10965588246047\cf2 , \cf6 17.522998328028542\cf2 ]]]), \cf4 region\cf2  
\f0\b =
\f1\b0  \cf5 /* color: #d63000 */
\f0\b \cf4 ee.Geometry.Polygon
\f1\b0 \cf2 ( [[[\cf6 -91.9912182924529\cf2 , \cf6 17.274023882734785\cf2 ], [\cf6 -92.16665382571077\cf2 , \cf6 17.414282393775412\cf2 ], [\cf6 -92.28887397992244\cf2 , \cf6 17.34154474499094\cf2 ], [\cf6 -92.10584214256652\cf2 , \cf6 17.199502321336027\cf2 ]]]);\
\
//////////// Get Image ////////////\
\
// Region: Tseltal Mayan Coffee Villages (Chiapas, Mexico)\
var point = ee.Geometry.Point([-92.18 , 17.28]);\
Map.centerObject(point, 12);\
\
// Image source:  Landsat 8\
var landsat8 = ee.ImageCollection('LANDSAT/LC08/C02/T1_L2')\
    .filterDate('2015-01-01', '2016-12-31')\
    .filterBounds(point)\
    .select(\
        ['SR_B2', 'SR_B3', 'SR_B4', 'SR_B5' , 'SR_B6', 'SR_B7'],\
        ['blue' , 'green', 'red'  , 'nir'   , 'swir1', 'swir2']\
);\
\
// Time periods: Pre-Coffee Harvest 2015-2016\
\
/* \
Previous studies have shown that images should not be more\
than one year apart because the forest degradation disturbance\
quickly disappears with tree foliage and understory vegetation growth.\
Changes in NDFI are a good indicator of forest change.\
*/\
\
var chiapasPre = landsat8\
    .filterDate('2015-09-01', '2015-12-31')\
    .sort('CLOUD_COVER', true)\
    .first()\
    .multiply(0.0000275)\
    .add(-0.2);\
\
var chiapasPost = landsat8\
    .filterDate('2016-09-01', '2016-12-31')\
    .sort('CLOUD_COVER', true)\
    .first()\
    .multiply(0.0000275)\
    .add(-0.2);\
\
\
// Image parameters\
\
var imageVis = \
\{\
    'opacity': 1,\
    'bands': ['swir1', 'nir', 'red'],\
    'min': 0,\
    'max': 0.4,\
    'gamma': 1\
\};\
\
print(landsat8)\
print(chiapasPre)\
\
\
///// Create spectral mixture analysis (SMA) /////\
\
// create fraction endmembers\
var endmembers = \
[\
  [0.0119,  0.0475,  0.0169,  0.625 , 0.2399, 0.0675], // Green Vegetation (GV)\
  [0.1514,  0.1597,  0.1421,  0.3053, 0.7707, 0.1975], // Non-Photosynthetic Vegetation (NPV)\
  [0.1799,  0.2479,  0.3158,  0.5437, 0.7707, 0.6646], // Soil\
  [0.4031,  0.8714,  0.79  ,  0.8989, 0.7002, 0.6607]  // Cloud\
];\
\
// Create fractions function\
var getSMAFractions = function(chiapasPre, endmembers) \
\{\
    var unmixed = ee.Image(chiapasPre)\
        .select([0, 1, 2, 3, 4, 5 ]) \
        .unmix(endmembers)\
        .max(0) \
        .rename('GV', 'NPV', 'Soil', 'Cloud');\
    return ee.Image(unmixed.copyProperties(chiapasPre));\
\};\
\
// SMA parameters\
\
var fractionVis = \
\{\
    'opacity': 1,\
    'min': 0.0,\
    'max': 0.5\
\};\
\
// Pre and Post variables\
\
var smaPre  = getSMAFractions(chiapasPre  , endmembers);\
var smaPost = getSMAFractions(chiapasPost , endmembers);\
\
// Add SMA bands\
\
var Shade = smaPre.reduce(ee.Reducer.sum())\
    .subtract(1.0)\
    .abs()\
    .rename('Shade');\
\
var GVs = smaPre.select('GV')\
    .divide(Shade.subtract(1.0).abs())\
    .rename('GVs');\
\
smaPre = smaPre.addBands([Shade, GVs]);\
\
/////// Create Normalized Difference Fraction Index (NDFI) ///////////////\
\
\
function getNDFI(smaImage) \
\{\
    var Shade = smaImage.reduce(ee.Reducer.sum())\
        .subtract(1.0)\
        .abs()\
        .rename('Shade');\
\
    var GVs = smaImage.select('GV')\
        .divide(Shade.subtract(1.0).abs())\
        .rename('GVs');\
        \
  smaImage = smaImage.addBands([Shade, GVs]);\
     var ndfi = smaImage.expression(\
        '(GVs - (NPV + Soil))  / (GVs + NPV + Soil)', \
      \{\
            'GVs': smaImage.select('GVs'),\
            'NPV': smaImage.select('NPV'),\
            'Soil': smaImage.select('Soil')\
      \}\
    ).rename('NDFI');\
  return ndfi;\
\}\
\
// Color palette\
var palettes = require(\
  'projects/gee-edu/book:Part A - Applications/A3 - Terrestrial Applications/A3.4 Forest Degradation and Deforestation/modules/palettes'\
);\
var ndfiColors  = palettes.ndfiColors;\
\
// Parameters\
var ndfiVis =\
\{\
        bands: ['NDFI'],\
        min: -1,\
        max: 1,\
        palette: ndfiColors\
\};\
\
// Create water & cloud masks\
var getWaterMask = function(smaPre) \
\{\
    var waterMask = (smaPre.select('Shade').gte(0.65))\
        .and(smaPre.select('GV')           .lte(0.15))\
        .and(smaPre.select('Soil')         .lte(0.05));\
    return waterMask.rename('Water');\
\};\
\
var cloud = smaPre.select('Cloud').gte(0.1);\
var water = getWaterMask(smaPre);\
\
var cloudWaterMask = cloud.max(water);\
\
print(smaPre, "SMA")\
\
// Pre and Post variables\
var ndfiPre     = getNDFI(smaPre);\
var ndfiPost    = getNDFI(smaPost);\
\
\
///////// Display Pre and Post layers  ///////////\
\
// RBG Layers\
Map.addLayer(chiapasPre , imageVis  , 'Landsat 8 RGB pre'   , false);\
Map.addLayer(chiapasPost, imageVis  , 'Landsat 8 RGB post'  , false);\
\
// SMA Layers\
Map.addLayer(smaPre.select('Soil')  , fractionVis , 'Soil Fraction' , false);\
Map.addLayer(smaPre.select('GV')    , fractionVis , 'GV Fraction'   , false);\
Map.addLayer(smaPre.select('NPV')   , fractionVis , 'NPV Fraction'  , false);\
\
// NDFI Layers\
Map.addLayer(ndfiPre                , ndfiVis     , 'NDFI pre'      , true);\
Map.addLayer(ndfiPost               , ndfiVis     , 'NDFI Post'     , true);\
\
// Masked Layer\
Map.addLayer(cloudWaterMask.selfMask(),\
\{\
        min: 1,\
        max: 1,\
        palette: 'blue'\
\},\
        'Cloud and water mask', false);\
\
\
//////////   Change Analysis   ///////////\
\
\
var ndfi = ndfiPre.select('NDFI')\
    .addBands(ndfiPost.select('NDFI'))\
    .rename('NDFI_Pre', 'NDFI_Post');\
\
// Calculate the NDFI change.\
var ndfiChange = ndfi.select('NDFI_Post')\
    .subtract(ndfi.select('NDFI_Pre'))\
    .rename('NDFI Change');\
\
// Create Histogram of NDFI change\
var options = \
\{\
    title: 'NDFI Difference Histogram',\
    fontSize: 20,\
    hAxis:  \{ title: 'Change'    \},\
    vAxis:  \{ title: 'Frequency' \},\
    series: \{ 0: \{ color: 'green'\}   \}\
\};\
\
var histNDFIChange = ui.Chart.image.histogram(ndfiChange\
                  .select('NDFI Change'), region, 25)\
                  .setSeriesNames(['NDFI Change'])\
                  .setOptions(options);\
\
print(histNDFIChange);\
\
/// Create a Classification layer of NDFI difference.\
var changeClassification = ndfiChange.expression(\
    '(b(0) >= -0.095 && b(0) <= 0.095) ? 1 :' +     //  No forest change\
    '(b(0) >= -0.250 && b(0) <= -0.095) ? 2 :' +    // Logging\
    '(b(0) <= -0.250) ? 3 :' +                      // Deforestation\
    '(b(0) >= 0.095) ? 4  : 0')                     // Vegetation regrowth\
    .updateMask(ndfi.select('NDFI_Pre')\
    .gt(0.60)                                       // mask out no forest\
);                    \
\
// Create threshold for forest\
var forest = ndfi.select('NDFI_Pre').gt(0.60);\
\
// Add additional layers to map\
Map.addLayer(ndfi, \
\{'bands': ['NDFI_Pre', 'NDFI_Post', 'NDFI_Post']\} , 'NDFI Change'      , false);\
Map.addLayer(ndfiChange , \{\}                      , 'NDFI Difference'  , false);\
Map.addLayer(forest     , \{\}                      , 'Forest Pre '      , false);\
\
Map.addLayer(changeClassification, \
\{palette: ['000000', '1eaf0c', 'ffc239', 'ff422f', '74fff9']\}, 'Change Classification', false);\
\
\
//////// Using NBR  /////////////\
\
var preImage = landsat8\
    .filterBounds(point)\
    .filterDate('2015-09-01', '2015-12-31')\
    .sort('CLOUD_COVER', true)\
    .first();\
    \
var postImage = landsat8\
    .filterBounds(point)\
    .filterDate('2016-09-01', '2016-12-31')\
    .sort('CLOUD_COVER', true)\
    .first();\
\
var nbrPre = preImage.normalizedDifference(['nir', 'swir2'])\
    .rename('nbr_pre');\
var nbrPost = postImage.normalizedDifference(['nir', 'swir2'])\
    .rename('nbr_post');\
    \
// 2-date change.\
var diff = nbrPost.subtract(nbrPre).rename('change');\
\
var nbrPalette = \
[\
    '011959', '0E365E', '1D5561', '3E6C55', '687B3E',\
    '9B882E', 'D59448', 'F9A380', 'FDB7BD', 'FACCFA'\
];\
var visParams = \
\{\
    palette: nbrPalette,\
    min: -0.2,\
    max: 0.2\
\};\
Map.addLayer(diff, visParams, 'change');\
\
// Classify change \
var thresholdGain =   0.2;\
var thresholdLoss =  -0.2;\
\
var diffClassified = ee.Image(0);\
\
diffClassified = diffClassified.where(diff.lte(thresholdLoss), 2);\
diffClassified = diffClassified.where(diff.gte(thresholdGain), 1);\
\
var changeVis = \{\
    palette: 'fcffc8,2659eb,fa1373',\
    min: 0,\
    max: 2\
\};\
\
Map.addLayer(diffClassified.selfMask(),\
    changeVis,\
    'NBR change classified by threshold');\
    \
/////// NDVI /////////////////\
\
var ndviPre = chiapasPre.normalizedDifference(['nir', 'red'])\
                      .rename('ndvi_pre');\
                      \
\
var ndviPost = chiapasPost.normalizedDifference(['nir', 'red'])\
                        .rename('ndvi_post');\
                        \
\
var vegPalette = ['red', 'white', 'green'];\
\
var ndviVisPar = \
\{\
    palette: vegPalette,\
    min: -1,\
    max: 1\
\};\
\
var ndviDiff = ndviPost.subtract(ndviPre).rename('NDVI change');\
\
var ndviDiffClassified = ee.Image(0);\
\
ndviDiffClassified = ndviDiffClassified.where(ndviDiff.lte(thresholdLoss), 2);\
ndviDiffClassified = ndviDiffClassified.where(ndviDiff.gte(thresholdGain), 1);\
\
Map.addLayer(ndviPre  , ndviVisPar, 'NDVI pre',     false);\
Map.addLayer(ndviPost , ndviVisPar, 'NDVI post',    false);\
Map.addLayer(ndviDiff , visParams , 'NDVI change',  false);\
\
Map.addLayer(ndviDiffClassified.selfMask(), changeVis, 'NDVI change classified by threshold');}