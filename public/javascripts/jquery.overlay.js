Overlay = {
	Trigger: $.klass({
		initialize: function(options) {
			this.url = options.url
			this.method = options.method || "GET"
		},
		onclick: function() {
			var overlay = $("<div class='overlay'></div>")
			var backdrop = $("<div class='backdrop'></div>")
			overlay.append(backdrop)
			var loading = $("<div class='loading'>hee hee</div>")
			backdrop.append(loading)
			$(document.body).append(overlay)
			overlay.children(".backdrop").fadeTo("slow", 0.5)
			$.ajax({
				type: this.method,
				url: this.url,
				error: function(request, status, error) {
					var error = $("<div class='error content'>An error occurred with status code "+request.status+". Click to close.</div>")
					loading.remove()
					overlay.append(error)
				},
				success: function(data, status) {
					var content = $("<div class='content'></div>")
					var loaded = $("<div class='loaded'></div>")
					loading.remove()
					content.append(loaded)
					loaded.append(data)
					overlay.append(content)
				}
			})
			return false
		}
	}),
	Dismiss: $.klass({
		onclick: function(event) {
			var overlay = this.element
			while(overlay && (overlay.attr("class") != "overlay")) { overlay = $(overlay.parent()) }
			overlay && overlay.fadeTo("slow", 0, function() {
				$(this).remove()
			})
			return false
		}
	})
}

$(document).ready(function(){
	$("a[rel*=overlay][rel*=get], a[rel*=overlay][rel*=post]").each(function(i) {
		$(this).attach(Overlay.Trigger, {url: $(this).attr("href"), method: ($(this).attr("rel").indexOf("get")>0) ? "GET" : "POST"})
	})
	$("div.backdrop, a[rel=overlay close]").attach(Overlay.Dismiss, {})
})