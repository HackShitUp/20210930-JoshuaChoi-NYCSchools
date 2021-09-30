# 20210930-JoshuaChoi-NYCSchools

This project successfully implements the following:  
• **Custom Refresher:** Instead of the standard ```UIRefreshControl``` a custom ```LinearRefresher``` was made instead to reflect JPM's theme colors.  
• **Pagination (Infinite Scroll):** The requests made via the ```Service``` class limits items to ```10``` per result while simultaneously using the API's ```offset```. Ideally, calls to the server for pagination should utilize the last data source's id (i.e., "cursor," last object's id as opposed to keeping track of an arbitrary integer value — this is because there may be instances where data sources on the client may mutate).  
• **Light & Dark Mode Appearance:"** Support for light/dark mode changes.  
• **Persisted Likes:** Ability to favorite or un-favorite a school. Ideally, this implementation should sync with the database so that the likes persist even if a user "logs out." When a user favorites a school in the ```SchoolSATDetailViewController```, we use the ```SchoolCellDelegate``` and the ```SchoolSATDetailViewControllerDelegate``` to update the main screen to persist the favorite state.

# Pagination & Linear Refresher Demo
![Demo-Pagination](Demo-Pagination.gif?raw=true)

# Favorites Demo
![Demo-Favorite](Demo-Favorite.gif?raw=true)

# No Data Screenshot
![Demo-No-Data](Demo-No-Data.png?raw=true)
