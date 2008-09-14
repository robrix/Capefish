$("#capefish_cancel").livequery("click", function(event) {
	if(confirm("Are you sure you want to close the editor? Your changes will not be saved.")) {
		if(Overlay != undefined) {
			var dismiss = new Overlay.Dismiss()
			dismiss.element = $(this)
			dismiss.onclick(event)
		} else {
			window.location = "/pages"
		}
	}
})

$("#capefish_save").livequery("click", function() {
	var button = $(this)
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
			if(document.Overlay != undefined) {
				var dismiss = new Overlay.Dismiss()
				dismiss.element = button
				dismiss.onclick(event)
			} else {
				window.location = "/pages"
			}
		}
	})
})