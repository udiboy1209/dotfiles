/* See LICENSE file for copyright and license details. */

#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx  = 0;        /* border pixel of windows */
static const unsigned int gappx     = 8;        /* gap between windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const double focusopacity    = 1.0;
static const double unfocusopacity  = 0.85;
static const char *fonts[]          = { "Hack:size=8" ,
                                        "Material Design Icons:size=10",
                                      };
static const char dmenufont[]       = "Hack:size=8";

enum {Gray1, Gray2, Gray3, Gray4, Cyan, LightCyan, Magenta, LightMagenta, Blue, LightBlue, Red, LightRed, Green, LightGreen};
static const char color[][8] = {
        "#393939", /* gray1 */
        "#4A4A4C", /* gray2 */
        "#C7C8C9", /* gray3 */
        "#F3F3F4", /* gray4 */
        "#EA7D24", /* cyan */
        "#F79321", /* light cyan */
        "#652F90", /* magenta */
        "#A96EAF", /* light magenta */
        "#1CA1DB", /* blue */
        "#00AFDA", /* light blue */
        "#BF1E2D", /* red */
        "#E7515A", /* light red */
        "#9DBA3A", /* green */
        "#A9C938", /* light green */
};
static const char *colors[][3]      = {
	/*                 fg           bg            border   */
	[SchemeNorm]     = { color[Gray3], color[Gray1], color[Gray4] },
	[SchemeSel]      = { color[Gray2], color[LightBlue], color[Blue] },
	[SchemeTitle]    = { color[Gray3], color[Gray2], color[Blue] },
	[SchemeTitleSel] = { color[Red], color[Gray3], color[Blue] },
};

static const char *statuscolors[][5] = {
        { color[Gray3], color[Gray2], color[Gray2] }, /* dark */
        { color[Gray1], color[Gray3], color[Gray4] }, /* light */
        { color[Gray1], color[LightBlue], color[Blue] },
        { color[Gray1], color[LightRed], color[Red] },
        { color[Gray1], color[LightGreen], color[Green] },
        { color[Gray1], color[LightMagenta], color[Magenta] },
};


/* tagging */
static const char *tags[] = { "1", "2", "3", "4" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class                  instance    title       tags mask     isfloating isignored  monitor */
	{ "Gimp",                 NULL,       NULL,       0,            1,         0,               -1 },
        { "Termite",              NULL,       "cava",     ~0,            1,         1,               -1 },
	//{ "processing-app-Base",  NULL,       NULL,       0,            1,       0,               -1 },
};

/* layout(s) */
static const float mfact     = 0.5; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "TTT",      bstack },
	{ "===",      bstackhoriz },
	{ "[M]",      monocle },
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ NULL,       NULL },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", color[Gray1], "-nf", color[Gray3], "-sb", color[Blue], "-sf", color[Gray2], NULL };
static const char *dmenutermcmd[] = { "dmenu_term", "-m", dmenumon, "-fn", dmenufont, "-nb", color[Gray1], "-nf", color[Gray3], "-sb", color[Blue], "-sf", color[Gray2], NULL };
static const char *dmenunetcmd[] = { "dmenu_net", "-i", "-m", dmenumon, "-fn", dmenufont, "-nb", color[Gray1], "-nf", color[Gray3], "-sb", color[Blue], "-sf", color[Gray2], NULL };
static const char *termcmd[] = { "termite", NULL };
static const char *slock[] = { "slock", NULL };

static const char *volumeup[]  = { "amixer", "-q", "sset", "Master", "3+", NULL };
static const char *volumedown[]  = { "amixer", "-q", "sset", "Master", "3-", NULL };
static const char *volumemute[]  = { "amixer", "-q", "-D", "pulse", "sset", "Master", "toggle", NULL };
static const char *brightup[]  = { "xbacklight", "+5", NULL};
static const char *brightdown[]  = { "xbacklight", "-5", NULL};
static const char *musicnext[]  = { "mpc", "next", NULL};
static const char *musicprev[]  = { "mpc", "prev", NULL};
static const char *musictoggle[]  = { "mpc", "toggle", NULL};

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY,                       XK_e,      spawn,          {.v = dmenutermcmd } },
	{ MODKEY,                       XK_n,      spawn,          {.v = dmenunetcmd } },
	{ MODKEY,                       XK_t,      spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY|ShiftMask,             XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY|ShiftMask,             XK_f,      setlayout,      {.v = &layouts[4]} },
	{ MODKEY|ShiftMask,             XK_m,      setlayout,      {.v = &layouts[3]} },
	{ MODKEY|ShiftMask,             XK_u,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY|ShiftMask,             XK_o,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	{ MODKEY|ControlMask,		XK_comma,  cyclelayout,    {.i = -1 } },
	{ MODKEY|ControlMask,           XK_period, cyclelayout,    {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	{ MODKEY|ShiftMask,             XK_e,      quit,           {0} },
        { 0,                            XF86XK_AudioRaiseVolume,  spawn, {.v = volumeup } },
        { 0,                            XF86XK_AudioLowerVolume,  spawn, {.v = volumedown } },
        { 0,                            XF86XK_AudioMute,         spawn, {.v = volumemute } },
        { 0,                            XF86XK_MonBrightnessUp,   spawn, {.v = brightup } },
        { 0,                            XF86XK_MonBrightnessDown, spawn, {.v = brightdown } },
        { 0,                            XF86XK_AudioNext,         spawn, {.v = musicnext } },
        { 0,                            XF86XK_AudioPrev,         spawn, {.v = musicprev } },
        { 0,                            XF86XK_AudioPlay,         spawn, {.v = musictoggle } },
        {MODKEY|ShiftMask,              XK_l,      spawn,         {.v = slock }},
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

