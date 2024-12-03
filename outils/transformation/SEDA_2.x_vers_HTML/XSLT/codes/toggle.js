function mytoggle(eltId) {
	var elt = document.getElementById(eltId);
	elt.style.display = (elt.style.display == "block") ? "none" : "block";
}

function toggle(event, item) {
	event = event || window.event;
	if (event.stopPropagation instanceof Function) event.stopPropagation();
	else event.cancelBubble = true;
	if (item.className == "expandable") {
		processVisibility(item, true);
		item.className = "expanded";
	} else if (item.className == "expanded") {
		item.className = "expandable";
		processVisibility(item, false);
	}
	return false;
}

function processVisibility(item, visible) {
	var childs = item.childNodes;
	for (var i = 0; i < childs.length; i++) {
		if ((childs.item(i).className == "ArchiveUnit") ||
			(childs.item(i).className == "Document") ||
			(childs.item(i).className == "Attachment")) {
		if (visible) {
			childs.item(i).style.display = "block";
		} else {
			childs.item(i).style.display = "none";
			}
		}
	}
}

function expandAll(visible) {
	var theClass = 'expanded';
	if (visible) {
		theClass = 'expandable';
	}
	var allHTMLTags = document.getElementsByTagName("*");
	for (var i = 0; i < allHTMLTags.length; i++) {
		var tag = allHTMLTags[i];
		if (tag.className == theClass) {
			processVisibility(tag, visible);
			if (visible) {
				tag.className = "expanded";
			} else {
				tag.className = "expandable";
			}
		}
	}
}