/* See LICENSE file for copyright and license details. */

#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx  = 0;        /* border pixel of windows */
static const unsigned int gappx     = 8;        /* gap between windows */
static const unsigned int snap      = 4;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const double focusopacity    = 1.0;
static const double unfocusopacity  = 0.85;
static const char *fonts[]          = { "Iosevka:size=8" ,
                                        "Material Design Icons:size=10",
                                      };
static const char dmenufont[]       = "Iosevka:size=8";

#include "colors.h"
#define color themecolor
static const char *colors[][3]      = {
       /*                 fg           bg            border   */
       [SchemeNorm]     = { color[Gray2], color[LightYellow], color[Gray4] },
       [SchemeSel]      = { color[Gray1], color[Red], color[Blue] },
       [SchemeTitle]    = { color[Gray2], color[LightRed], color[Blue] },
       [SchemeTitleSel] = { color[Gray1], color[Red], color[Blue] },
};
static const char *statuscolors[][3] = {
        { color[Gray3], color[Gray2], color[Gray2] }, /* dark */
        { color[Gray1], color[Gray3], color[Gray4] }, /* light */
        { color[Gray1], color[LightBlue], color[Blue] },
        { color[Gray1], color[LightRed], color[Red] },
        { color[Gray1], color[LightGreen], color[Green] },
        { color[Gray1], color[Yellow], color[Yellow] },
};

/* tagging */
char *tags[] = { "A", "B", "C", "D", "E", "F" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class                  instance    title       tags mask     isfloating isignored  monitor */
	{ "Gimp",                 NULL,       NULL,       0,            1,         0,               -1 },
        { "Matplotlib",           NULL,       NULL,       0,            1,         0,                -1 },
        { "feh",                  NULL,       NULL,       0,            1,         0,               -1 },
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

#define DMENUOPTS "-m",dmenumon,"-fn",dmenufont,"-nb",color[LightYellow],"-nf",color[Gray2],"-sb",color[LightRed],"-sf",color[Gray2]
/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "deskrun", DMENUOPTS, NULL };
static const char *dmenutermcmd[] = { "dmenu_term", DMENUOPTS, NULL };
static const char *dmenunetcmd[] = { "dmenu_net", "-i", "-p", "Netcfg", DMENUOPTS, NULL };
static const char *dmenuexecmd[] = { "dmenu_exec", "-p", "Execute", DMENUOPTS, NULL };
static const char *termcmd[] = { "st", "-e", "/usr/bin/fish", NULL };
static const char *initcmd[] = { "/home/udiboy/.local/bin/dwm-init.sh", NULL};
static const char *lock[] = { "i3lock-blur", NULL };
static const char *browsercmd[] = { "firefox", NULL };

static const char *volumeup[]  = { "pamixer", "-i", "5", NULL };
static const char *volumedown[]  = { "pamixer", "-d", "5", NULL };
static const char *volumemute[]  = { "pamixer", "-t", NULL };
static const char *brightup[]  = { "xbacklight", "+5", NULL};
static const char *brightdown[]  = { "xbacklight", "-5", NULL};
static const char *musicnext[]  = { "mpc", "next", NULL};
static const char *musicprev[]  = { "mpc", "prev", NULL};
static const char *musictoggle[]  = { "mpc", "toggle", NULL};

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY,                       XK_e,      spawn,          {.v = dmenutermcmd } },
	{ MODKEY,                       XK_c,      spawn,          {.v = dmenuexecmd } },
	{ MODKEY,                       XK_n,      spawn,          {.v = dmenunetcmd } },
	{ MODKEY,                       XK_t,      spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY|ShiftMask,             XK_h,      setcfact,       {.f = -0.25} },
	{ MODKEY|ShiftMask,             XK_l,      setcfact,       {.f = +0.25} },
	{ MODKEY|ShiftMask,             XK_o,      setcfact,       {.f = 1.0} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY|ShiftMask,             XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY|ShiftMask,             XK_f,      setlayout,      {.v = &layouts[4]} },
	{ MODKEY|ShiftMask,             XK_m,      setlayout,      {.v = &layouts[3]} },
	{ MODKEY|ShiftMask,             XK_u,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY|ShiftMask,             XK_o,      setlayout,      {.v = &layouts[2]} },
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
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	{ MODKEY|ShiftMask,             XK_e,      quit,           {0} },
        { 0,                            XF86XK_AudioRaiseVolume,  spawn, {.v = volumeup } },
        { 0,                            XF86XK_AudioLowerVolume,  spawn, {.v = volumedown } },
        { 0,                            XF86XK_AudioMute,         spawn, {.v = volumemute } },
        { 0,                            XF86XK_MonBrightnessUp,   spawn, {.v = brightup } },
        { 0,                            XF86XK_MonBrightnessDown, spawn, {.v = brightdown } },
        { 0,                            XF86XK_AudioNext,         spawn, {.v = musicnext } },
        { 0,                            XF86XK_AudioPrev,         spawn, {.v = musicprev } },
        { 0,                            XF86XK_AudioPlay,         spawn, {.v = musictoggle } },
        {MODKEY|ControlMask|ShiftMask,  XK_l,      spawn,         {.v = lock }},
        {MODKEY,                        XK_s,      spawn,         {.v = browsercmd }},
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button1,        zoom,           {0} },
//	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY|ShiftMask,Button1,       resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

#undef color

