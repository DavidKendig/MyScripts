# Script for backing up Redmine

import os
import datetime
import glob
import tarfile

date = str(datetime.date.today())
src = "C:/Users/SCiPnet/Downloads"
dst = "C:/Users/SCiPnet/Desktop/Redmine"

archive_name = "Redmine-"+date

if os.path.exists(dst) == False:
    os.mkdir(dst)

print("Compressing files to %s.tar.gz" % archive_name)
tar = tarfile.open(dst+"/"+archive_name+".tar.gz", "w:gz")
for file_name in glob.glob(os.path.join(src, "*")):
    print("  Adding %s..." % file_name)
    tar.add(dst)
