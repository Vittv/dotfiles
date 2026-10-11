/*
 * xhotkey - grab-free global hotkey for X
 *
 * usage: xhotkey <keysym> <command> [args...]
 *
 * runs <command> every time <keysym> is pressed, without ever grabbing the
 * keyboard. dwm/i3 style binds use XGrabKey: on the hotkey press the server
 * redirects *every* key event to the WM until the key is released, so the
 * focused app (a game) misses events -- e.g. the release of a movement key
 * it is still holding -- and gets stuck. this only reads the server's global
 * key state instead, so all keys keep flowing to the focused window as usual.
 *
 * build: cc -O2 -o xhotkey xhotkey.c -lX11
 */
#include <X11/Xlib.h>
#include <X11/keysym.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <sys/wait.h>

#define POLL_MS 10 /* a human tap is way longer than this, so no press is missed */

int
main(int argc, char **argv)
{
	if (argc < 3) {
		fprintf(stderr, "usage: %s <keysym> <command> [args...]\n", argv[0]);
		return 1;
	}

	Display *dpy = XOpenDisplay(NULL);
	if (!dpy) {
		fprintf(stderr, "xhotkey: cannot open display\n");
		return 1;
	}

	KeySym sym = XStringToKeysym(argv[1]);
	if (sym == NoSymbol) {
		fprintf(stderr, "xhotkey: unknown keysym \"%s\"\n", argv[1]);
		return 1;
	}

	KeyCode code = XKeysymToKeycode(dpy, sym);
	if (!code) {
		fprintf(stderr, "xhotkey: keysym \"%s\" is not bound to any key\n", argv[1]);
		return 1;
	}

	signal(SIGCHLD, SIG_IGN); /* reap the commands we spawn */

	char keys[32];
	int prev = 0;
	struct timespec ts = { 0, POLL_MS * 1000000L };

	for (;;) {
		XQueryKeymap(dpy, keys);
		int down = (keys[code >> 3] >> (code & 7)) & 1;

		/* rising edge only: holding or autorepeat fires once */
		if (down && !prev && fork() == 0) {
			execvp(argv[2], &argv[2]);
			_exit(127);
		}

		prev = down;
		nanosleep(&ts, NULL);
	}
}
