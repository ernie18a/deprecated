mkdir /media/rheldvd
mount /dev/sr0  /media/rheldvd
vi /etc/yum.repos.d/my.repo 
	[dvd-BaseOS]
	name=DVD for RHEL - BaseOS
	baseurl=file:///media/rheldvd/BaseOS
	enabled=1
	gpgcheck=1
	gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
	
	[dvd-AppStream]
	name=DVD for RHEL - AppStream
	baseurl=file:///media/rheldvd/AppStream
	enabled=1
	gpgcheck=1
	gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
yum clean all
yum  --noplugins list
