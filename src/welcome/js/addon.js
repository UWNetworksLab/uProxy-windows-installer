// This script keeps the addon visible on any page until
// it's closed

// Create addOnClosed variable and display addon 
// when user first opens site
if (localStorage.getItem("addOnClosed") === null) {
	$(".addon").css('display', 'block');
	localStorage.setItem("addOnClosed", false);
}

// Display addon if it hasn't been closed yet
if (localStorage.getItem("addOnClosed") === "false") {
	$(".addon").css('display', 'block');
}

function closeAddOn(){
  localStorage.setItem("addOnClosed", true);
  $(".addon").css('display', 'none');
}