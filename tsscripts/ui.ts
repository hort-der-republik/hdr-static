// Interactive behaviours the XSLT templates rely on.
//
//   data-toggle="collapse|dropdown" + aria-controls="<id>"  show/hide the target (class "hidden")
//   data-dialog="<id>" (or "#<id>")                          open the <dialog> with that id
//   data-dismiss="<selector>"                                remove the closest matching ancestor

function setExpanded(trigger: HTMLElement, open: boolean): void {
	const target = document.getElementById(trigger.getAttribute("aria-controls") ?? "");
	if (!target) return;
	trigger.setAttribute("aria-expanded", String(open));
	target.classList.toggle("hidden", !open);
}

function closeDropdowns(except?: HTMLElement): void {
	document
		.querySelectorAll<HTMLElement>('[data-toggle="dropdown"][aria-expanded="true"]')
		.forEach((trigger) => {
			if (trigger !== except) setExpanded(trigger, false);
		});
}

function openDialog(ref: string): void {
	const dialog = document.getElementById(ref.replace(/^#/, ""));
	if (dialog instanceof HTMLDialogElement) dialog.showModal();
}

// entity markers are spans; make them reachable and operable by keyboard
document.querySelectorAll<HTMLElement>("[data-dialog]").forEach((el) => {
	el.setAttribute("role", "button");
	el.tabIndex = 0;
});

document.addEventListener("click", (event) => {
	const el = event.target;
	if (!(el instanceof Element)) return;

	// a click on the dialog element itself (not its content) is a click on the backdrop
	if (el instanceof HTMLDialogElement) {
		el.close();
		return;
	}

	const toggle = el.closest<HTMLElement>("[data-toggle]");
	if (toggle) {
		event.preventDefault();
		if (toggle.dataset.toggle === "dropdown") closeDropdowns(toggle);
		setExpanded(toggle, toggle.getAttribute("aria-expanded") !== "true");
		return;
	}
	closeDropdowns();

	const dismiss = el.closest<HTMLElement>("[data-dismiss]");
	if (dismiss) {
		dismiss.closest(dismiss.dataset.dismiss!)?.remove();
		return;
	}

	const dialogTrigger = el.closest<HTMLElement>("[data-dialog]");
	if (dialogTrigger) openDialog(dialogTrigger.dataset.dialog!);
});

document.addEventListener("keydown", (event) => {
	if (event.key === "Escape") {
		closeDropdowns();
		return;
	}
	const el = event.target;
	if (
		(event.key === "Enter" || event.key === " ") &&
		el instanceof HTMLElement &&
		el.dataset.dialog
	) {
		event.preventDefault();
		openDialog(el.dataset.dialog);
	}
});
