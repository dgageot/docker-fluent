import net.codestory.http.WebServer;
import net.codestory.http.appengine.AppEngineFilter;

public class MainWeb {
  public static void main(String[] args) {
    new WebServer().configure(routes -> routes.add(AppEngineFilter.class)).start();
  }
}
