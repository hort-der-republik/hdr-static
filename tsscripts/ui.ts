function setExpanded(trigger: HTMLElement, open: boolean): void {
	const target = controlledBy(trigger);
	if (!target) return;
	trigger.setAttribute("aria-expanded", String(open));
	target.classList.toggle("hidden", !open);
}

function controlledBy(trigger: HTMLElement): HTMLElement | null {
	return document.getElementById(trigger.getAttribute("aria-controls") ?? "");
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
document.querySelectorAll<HTMLElement>("[data-dialog]:not(button)").forEach((el) => {
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

// Escape closes an open dropdown; if focus was on its trigger or inside it, focus goes back to
// the trigger. Returns whether it closed one, so a dialog around it stays open for now.
function closeDropdownOnEscape(): boolean {
	const trigger = [
		...document.querySelectorAll<HTMLElement>('[data-toggle="dropdown"][aria-expanded="true"]'),
	].find((t) => t.checkVisibility());
	if (!trigger) return false;
	const focused = document.activeElement;
	const hadFocus = trigger === focused || Boolean(controlledBy(trigger)?.contains(focused));
	setExpanded(trigger, false);
	if (hadFocus) trigger.focus();
	return true;
}

// Crossing the lg breakpoint switches between the drawer (dialog.drawer, mobile only) and the
// inline navigation: close dropdowns, and the drawer when switching to desktop, so nothing stays
// open in a layout it wasn't opened in. matchMedia instead of "resize", which also fires on phones
// when the address bar or the keyboard shows or hides. Must match Tailwind's lg breakpoint.
const desktopLayout = window.matchMedia("(min-width: 64rem)");
desktopLayout.addEventListener("change", (event) => {
	const drawers = event.matches
		? document.querySelectorAll<HTMLDialogElement>("dialog.drawer[open]")
		: [];
	const dropdowns = document.querySelectorAll('[data-toggle="dropdown"][aria-expanded="true"]');
	if (drawers.length === 0 && dropdowns.length === 0) return;
	closeDropdowns();
	drawers.forEach((dialog) => dialog.close());
	// focus may have been in what just closed. The new layout's styles apply only after this event,
	// so check a frame later whether focus is lost: on body, or on a hidden element (closing the
	// drawer returns it to the menu button, hidden on desktop). Then move it to the first visible
	// header button: the menu button on mobile, the first dropdown button on desktop.
	requestAnimationFrame(() => {
		const current = document.activeElement;
		if (current instanceof HTMLElement && current !== document.body && current.checkVisibility()) {
			return;
		}
		[...document.querySelectorAll<HTMLElement>("header button")]
			.find((button) => button.checkVisibility())
			?.focus();
	});
});

// a dropdown closes when Tab moves focus out of it; relatedTarget is null when the window
// loses focus, which keeps it open
document.addEventListener("focusout", (event) => {
	const next = event.relatedTarget;
	if (!(next instanceof Node)) return;
	document
		.querySelectorAll<HTMLElement>('[data-toggle="dropdown"][aria-expanded="true"]')
		.forEach((trigger) => {
			if (!trigger.contains(next) && !controlledBy(trigger)?.contains(next)) {
				setExpanded(trigger, false);
			}
		});
});

document.addEventListener("keydown", (event) => {
	if (event.key === "Escape") {
		// stops the browser from also closing the drawer around the dropdown
		if (closeDropdownOnEscape()) event.preventDefault();
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
