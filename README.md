AMImageManager
==============

AMImageManager is a library for managing images in an IOS app. 
This library includes Following classes.

  	1.	Indicator
	2.	AMImageCache
	3.	AMImageManager
	4.	AMImageView
	5.	CacheItem
	6.	Database
	7.	DateUtil
	8.	ImageCachingDatabaseService
	9.	ImageRequest

Short description for each of the classes.

	1.	Indicator - 
			This is a UIView subclass which contains an progress indicator and a string for describing the progress. Can be used by just creating the object of the class using the custom Init method. 

	2.	AMImageCache - 
			This class is used to manage the Cache. This class has a dictionary of cache items having URL of the images as the key. This class also takes care of the cache size. This maintains a size of 5 MB. The data is refreshed using LRU algorithm.

	3.	AMImageManager -
			This class does the actual cache managing job. it creates, handles the cache and also storage of images in the local database.

	4.	AMImageView -
			its a custom image view to which the developer can either give an UIImage object or url of the image. if URL is received, it downloads the image asynchronously and stores that in the database and cache for future use.

	5.	CacheItem -  
			is the model class for an image that is cached. 
	7.		
	6.	Database -  
			base database class which creates the database object. and define basic functionalities of database classes.

	7.	DateUtil - 
			class that defines few date comparison utilities.

	8.	ImageCachingDatabaseService -
			a derived class of Database which defines all functionalities for the image cache database.

	9.	ImageRequest -
			a derived class of ASIHTTPRequest for downloading Images asynchronously.

  	
	    
  The cache is a dictionary where 
 
 	•  Key : URL of the image
  	•  Value : Cache Item that stores size , data, URL and last accessed time of the Image.

  Each time when an image is to be loaded, the library goes with following order of checking.
  
 		If (image is in chache){
 		 	Use the image
		  }
		else {
 		 	if (image is in database){
  				get the image to cache
  				use the image
    		}
    			else{
    				download the image using URL
    				store image in the database
			    	store image in cache.
    			}
  		}

 
