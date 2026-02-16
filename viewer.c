#include <gtk/gtk.h>
#include <webkit2/webkit2.h>

static gboolean on_key_press(GtkWidget *widget, GdkEventKey *event, gpointer data) {
    if (event->keyval == GDK_KEY_q || event->keyval == GDK_KEY_Q || event->keyval == GDK_KEY_Escape) {
        gtk_main_quit();
        return TRUE;
    }
    return FALSE;
}

int main(int argc, char *argv[]) {
    gtk_init(&argc, &argv);

    g_set_prgname("definition-viewer");
    g_set_application_name("Definition Viewer");

    GtkWindow *window = GTK_WINDOW(gtk_window_new(GTK_WINDOW_TOPLEVEL));
    gtk_window_set_title(window, "Definition Viewer");
    gtk_window_set_role(window, "definition-viewer");
    gtk_window_set_default_size(window, 600, 400);
    gtk_window_resize(window, 500, 300);

    WebKitWebView *web_view = WEBKIT_WEB_VIEW(webkit_web_view_new());
    gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(web_view));

    char *uri = g_filename_to_uri("/tmp/definition.html", NULL, NULL);
    webkit_web_view_load_uri(web_view, uri);
    g_free(uri);

    g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);
    g_signal_connect(window, "key-press-event", G_CALLBACK(on_key_press), NULL);

    gtk_widget_show_all(GTK_WIDGET(window));
    gtk_main();

    return 0;
}
