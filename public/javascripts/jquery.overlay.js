Overlay = $.klass({
	initialize: function() {
		this.container = $("<div class='overlay'></div>")
		this.backdrop = $("<div class='backdrop'></div>")
		this.container.append(this.backdrop)
		this.loading = $("<div class='loading'></div>")
		this.content = $("<div class='content'></div>")
		this.loaded = $("<div class='loaded'></div>")
		this.content.append(this.loaded)
		this.unload()
	},
	show: function() {
		this.container.css("opacity", 1)
		$(document.body).append(this.container)
		var overlay = this
		this.backdrop.click(function() {
			overlay.hide()
			return false
		})
		this.backdrop.fadeTo("fast", 0.5)
	},
	load: function(data) {
		this.loading.remove()
		this.loaded.empty()
		this.loaded.append(data)
		var overlay = this
		this.container.append(this.content)
		this.container.find("input[type=button][name*=overlay], button[name*=overlay]").each(function(){
			this.overlay = overlay
		})
		this.container.find("a[rel=overlay close], input[type=button][name=overlay_close], button[name=overlay_close]").click(function() {
			overlay.hide()
			return false
		})
	},
	unload: function() {
		this.loaded.empty()
		this.content.remove()
		this.backdrop.append(this.loading)
	},
	hide: function() {
		var overlay = this
		this.container.fadeTo("fast", 0.0, function() {
			overlay.backdrop.css("opacity", 0)
			overlay.container.remove()
		})
	}
})

Overlay.Loader = $.klass({
	initialize: function(options) {
		this.url = options.url
		this.method = options.method || "GET"
		this.overlay = new Overlay()
	},
	onclick: function() {
		this.overlay.show()
		var overlay = this.overlay
		$.ajax({
			type: this.method,
			url: this.url,
			error: function(request, status, error) {
				overlay.load("<div class='error'><p>An error occurred with status code "+request.status+".</p><input type='button' name='overlay_close' value='OK'></div>")
			},
			success: function(data, status) {
				overlay.load(data)
			}
		})
		return false
	}
})

$(document).ready(function(){
	$("a[rel*=overlay][rel*=get], a[rel*=overlay][rel*=post]").each(function(i) {
		$(this).attach(Overlay.Loader, {url: $(this).attr("href"), method: ($(this).attr("rel").indexOf("post")>0) ? "POST" : "GET"})
	})
})