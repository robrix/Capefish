$("#capefish_new_page").attach(Overlay.Loader, {
	url: "/pages/new",
	method: "GET"
})


$("#capefish_cancel").livequery("click", function(event) {
	if(confirm("Are you sure you want to close the editor? Your changes will not be saved.")) {
		if(this.overlay) {
			this.overlay.hide()
		} else {
			window.location = "/pages"
		}
	}
})

$("#capefish_save").livequery("click", function() {
	var button = this
	$.ajax({
		type: "POST",
		url: "/pages/"+$("#capefish_page_path").val(),
		data: {
			_method: "put",
			page_content: $("#capefish_editor").get()[0].innerHTML.replace(/<span class="erb">(.+?)<\/span>/, "<%$1%>"),
			authenticity_token: $("#capefish_authenticity_token").val()
		},
		error: function(request, status, error) {
			alert("An error with status code "+request.status+" occurred while saving.")
		},
		success: function(data, status) {
			if(button.overlay) {
				button.overlay.hide()
			} else {
				window.location = "/pages"
			}
		}
	})
})