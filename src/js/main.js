function love() {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "https://api.countapi.xyz/hit/lengy/test1");
    xhr.responseType = "json";
    xhr.onload = function() {
        document.getElementById("loves").innerText = this.response.value;
        document.getElementById("footer").classList.remove("hidden");
    };
    xhr.send();

    return false;
}
