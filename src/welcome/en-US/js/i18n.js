var RTL_LANGUAGES = {
  'ar': true,
  'fa': true,
  'ur': true,
  'he': true
};

window.i18nResources = {};
i18n.init({
  resStore: window.i18nResources,
  fallbackLng: 'en',
  useDataAttrOptions: true
});

function createI18nDictionary(sourceFile) {
  var i18nDictionary = {};
  for (var key in sourceFile) {
    i18nDictionary[key] = sourceFile[key]['message'];
  }
  return i18nDictionary;
}

function loadLanguage(lng) {
  if (i18n.hasResourceBundle(lng)) {
    return Promise.resolve();
  }
  return loadJSON("/locales/" + lng + "/messages.json").then(
      function(data){
        i18n.addResources(lng, 'translation', createI18nDictionary(data));
      }.bind(this));
}

function loadJSON(filename) {
  return new Promise(function(resolve, reject){
    $.getJSON(filename, function(data) {
      resolve(data);
    }.bind(this));
  });
}

From: http://www.w3schools.com/js/js_cookies.asp
function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1);
        if (c.indexOf(name) == 0) return c.substring(name.length,c.length);
    }
    return null;
}

function translatePage() {
  i18n.setLng(userLanguage);

  $('.i18n').each(function(index, element) {
    $(element).i18n();
  });

  if (RTL_LANGUAGES[userLanguage.substring(0,2)]) {
    document.querySelector('body').dir = 'rtl';
  } else {
    document.querySelector('body').dir = 'ltr';
  }

  // When setting or changing the language, Polymer elements need to be
  // notified that new language resources are ready, so that the elements'
  // translations can be refreshed.
  $.each(document.querySelectorAll('html /deep/ install-btn, uproxy-launch-btn'),
      function(index, element) {
    element.dispatchEvent(new CustomEvent("language-ready", {
      "detail": {
        "userLanguage" : userLanguage
      }
    }));
  });
}

i18n.addResources('en', 'translation',
    createI18nDictionary(languageResources['en']));
if (userLanguage != 'en') {
  i18n.addResources(userLanguage, 'translation',
      createI18nDictionary(languageResources[userLanguage]));
}

$(document).ready(translatePage);
