window.i18nResources = {};
i18n.init({
  resStore: window.i18nResources,
  fallbackLng: 'en',
  useDataAttrOptions: true
});

// Loads local json file. This only works on Firefox, Chrome gives the error "Cross 
// origin requests are only supported for protocol schemes: http, data, chrome, 
// chrome-extension, https, chrome-extension-resource."
// http://codepen.io/KryptoniteDove/post/load-json-file-locally-using-pure-javascript
function loadLanguage(filename) {
  var xobj = new XMLHttpRequest();
  xobj.overrideMimeType("text/plain");
  xobj.open('GET', filename, true);
  xobj.onreadystatechange = function () {
    if (xobj.readyState == 4 && xobj.status == "200") {
      updateLanguage(JSON.parse(xobj.responseText));
    }
  };
  xobj.send(null);  
}

function updateLanguage(jsonDictionary){
  var languageResources = jsonDictionary;
  i18n.addResources(userLanguage.substring(0,2), 'translation',
    createI18nDictionary(languageResources));
  translatePage();
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

// userLanguage doesn't matter because there
// will be one messages.json file per Windows 
// Installer; userLanguage has to be 2 characters.
var userLanguage = 'en';

// The install script grabs the messages.json file
// from the correct locale and puts it in the welcome 
// directory
var dictionaryFile = 'messages.json'

loadLanguage(dictionaryFile);
