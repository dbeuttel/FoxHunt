function autofields(items) {
	if (!items) items = $(".autofields").find("input, textarea, select");
	$(items).each(function () {
		var field = $(this);
		var name = field.attr("name");
		var type = field.attr("type");
		if (!type) type = "";
		type = type.toLocaleLowerCase();

		var id = field.attr("id");
        if ((!name && !id) || type == "hidden") {

		}
        else {
            if (type == "checkbox") {
                field = field.parent();
            }
			if (!id) field.attr("id", name);
			if (!name) field.attr("name", id);

			var icon = field.attr("icon");
			if (icon)
				icon = "<i class='autoicon fa fa-" + icon + "' ></i>";
			else
				icon = "";
			if (!field.attr("placeholder"))
				field.attr("placeholder", " ");
			var title = field.attr("title");
			if (!title)
				title = field.attr("placeholder");

			field
				.addClass("auto")
				.wrap("<div class='autofieldWrap'><div class='autofield'>")
				.after("<label class='auto' for='" + name + "'>" + icon + title + "</label>")
				.focus(function () { $(this).parent().addClass('autoFieldFocused'); })
				.blur(function () { $(this).parent().removeClass('autoFieldFocused'); });
			field.parent().parent().click(function () { field.focus(); });
		}

	});
}
