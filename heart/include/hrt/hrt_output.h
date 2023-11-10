#ifndef HRT_HRT_OUTPUT_H
#define HRT_HRT_OUTPUT_H

#include <wayland-server.h>

#include <wlr/types/wlr_output.h>

#include <hrt/hrt_server.h>

struct hrt_output {
  struct wlr_output *wlr_output;
  struct hrt_server *server;

  struct wl_listener frame;
  struct wl_listener destroy;

  // temp background color
  float color[4];
};

struct hrt_output_callbacks {
  void (*output_added)(struct hrt_output *output);
  void (*output_removed)(struct hrt_output *output);
};

bool hrt_output_init(struct hrt_server *server, const struct hrt_output_callbacks *callbacks);
#endif
