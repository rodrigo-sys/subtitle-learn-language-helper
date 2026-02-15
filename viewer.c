#include <gtk/gtk.h>
#include <webkit2/webkit2.h>

int main(int argc, char *argv[]) {
    gtk_init(&argc, &argv);

    GtkWindow *window = GTK_WINDOW(gtk_window_new(GTK_WINDOW_TOPLEVEL));
    gtk_window_set_title(window, "Definition");
    gtk_window_set_default_size(window, 600, 400);
    gtk_window_resize(window, 500, 300);

    WebKitWebView *web_view = WEBKIT_WEB_VIEW(webkit_web_view_new());
    gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(web_view));

    char *uri = g_filename_to_uri("/tmp/definition.html", NULL, NULL);
    webkit_web_view_load_uri(web_view, uri);
    g_free(uri);

    g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);

    gtk_widget_show_all(GTK_WIDGET(window));
    gtk_main();

    return 0;
}
