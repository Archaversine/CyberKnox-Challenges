# Password 

There was a data leak from a database (not really), and a hashed password for 
an admin account was found: `3fc0a7acf087f549ac2b266baf94b8b1`. This password 
was hashed using the MD5 hash, I wonder if those password requirements that 
are everywhere actually matter?

Once you find the password, wrap it in the `cyberknox{}` wrapper.
