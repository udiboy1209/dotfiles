/* See LICENSE file for copyright and license details. */

/* interval between updates (in ms) */
static const int interval = 1000;

/* text to show if no value can be retrieved */
static const char unknown_str[] = " ";

const char* print(const char* out) {
    return out;
}

/* maximum output string length */
#define MAXLEN 2048

/*
 * function             description                     argument
 *
 * battery_perc         battery percentage              battery name
 * battery_power        battery power usage             battery name
 * battery_state        battery charging state          battery name
 * cpu_perc             cpu usage in percent            NULL
 * cpu_iowait           cpu iowait in percent           NULL
 * cpu_freq             cpu frequency in MHz            NULL
 * datetime             date and time                   format string
 * disk_free            free disk space in GB           mountpoint path
 * disk_perc            disk usage in percent           mountpoint path
 * disk_total           total disk space in GB          mountpoint path
 * disk_used            used disk space in GB           mountpoint path
 * entropy              available entropy               NULL
 * gid                  GID of current user             NULL
 * hostname             hostname                        NULL
 * ipv4                 IPv4 address                    interface name
 * ipv6                 IPv6 address                    interface name
 * kernel_release       `uname -r`                      NULL
 * keyboard_indicators  caps/num lock indicators        NULL
 * load_avg             load average                    format string
 * num_files            number of files in a directory  path
 * ram_free             free memory in GB               NULL
 * ram_perc             memory usage in percent         NULL
 * ram_total            total memory size in GB         NULL
 * ram_used             used memory in GB               NULL
 * run_command          custom shell command            command
 * swap_free            free swap in GB                 NULL
 * swap_perc            swap usage in percent           NULL
 * swap_total           total swap size in GB           NULL
 * swap_used            used swap in GB                 NULL
 * temp                 temperature in degree celsius   sensor file
 * uid                  UID of current user             NULL
 * uptime               system uptime                   NULL
 * username             username of current user        NULL
 * vol_perc             OSS/ALSA volume in percent      "/dev/mixer"
 * wifi_perc            WiFi signal in percent          interface name
 * wifi_essid           WiFi ESSID                      interface name
 */
static const struct arg args[] = {
	/* function format     argument */
        { vol_perc, " %s%%\x04>", "/dev/mixer" },
        { ipv4, "%s\x05|", "enp2s0"},
        { ipv4, "%s\x05|", "wlp3s0"},
        { netspeed, "%5s\x05>", NULL},
        { wifi_essid, " %s\x06|", "wlp3s0"},
        { wifi_perc, " %s%%\x06>", "wlp3s0"},
        { mpd_status, " %s\x03>", NULL},

        { print, "%s", ";"},

        { cpu_perc, "<\x03 %2s%%", NULL },
        { cpu_freq, "|\x03%4sMHz", NULL },
        { ram_used, "<\x05 %sGB", NULL },
	{ datetime, "<\x02%s", " %a, %d %b  %T" },
};
