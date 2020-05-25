document.addEventListener("click", function(e)
{
    e = e || window.event;
    //if(e.target.value == 'Submit') //you can identify this button like this, but better like:
    if(e.target.getAttribute('onclick') == 'javascript:GotoURL(3)')
    //if this site has more elements with onclick="javascript:GotoURL(3)"
    //if(e.target.value == 'Submit' && e.target.getAttribute('onclick') == 'javascript:GotoURL(3)')
    {
        console.log(e.target.value);
        //if you need then you can call the following line on this place too:
        //window.webkit.messageHandlers.log.postMessage("submit");
    }
});


document.addEventListener("click", function(e) { e = e || window.event; if(e.target.getAttribute('class') == 'javascript:GotoURL(3)') { console.log(e.target.value); } });


