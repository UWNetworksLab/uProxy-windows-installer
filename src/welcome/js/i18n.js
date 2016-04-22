window.i18nResources = {};
i18n.init({
  resStore: window.i18nResources,
  fallbackLng: 'en',
  useDataAttrOptions: true
});

// Load local json file
// http://codepen.io/KryptoniteDove/post/load-json-file-locally-using-pure-javascript
function loadLanguage(filename, updatePage) {   
  var xobj = new XMLHttpRequest();
  xobj.overrideMimeType("text/plain");
  xobj.open('GET', filename, true);
  xobj.onreadystatechange = function () {
    if (xobj.readyState == 4 && xobj.status == "200") {
      updatePage(JSON.parse(xobj.responseText));
    }
  };
  xobj.send(null);  
}

function createI18nDictionary(sourceFile) {
  var i18nDictionary = {};
  for (var key in sourceFile) {
    i18nDictionary[key] = sourceFile[key]['message'];
  }
  return i18nDictionary;
}

function translatePage() {
  i18n.setLng(userLanguage);
  $('.i18n').each(function(index, element) {
    $(element).i18n();
  });
}

function updateLanguage(jsonDictionary){
  var languageResources = jsonDictionary;
  i18n.addResources(userLanguage.substring(0,2), 'translation',
    createI18nDictionary(languageResources));
  translatePage();
}

// userLanguage doesn't matter because there
// will be one messages.json file per Windows 
// Installer. userLanguage has to be 2 characters.
var userLanguage = 'en';
var dictionaryFile = 'messages.json'
loadLanguage(dictionaryFile, updateLanguage);
