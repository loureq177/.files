import type { Plugin } from "@opencode-ai/plugin";

export default (async () => {
  return {
    "permission.ask": async (input) => {
      // Trigger a desktop notification
      Bun.spawn(["notify-send", "-a", "Opencode", "Opencode requires your permission!", "Please check your terminal."]);
    }
  };
}) satisfies Plugin;
