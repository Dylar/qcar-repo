serviceVersion=$(grep 'serviceVersion' gradle.properties | cut -d '=' -f2)

serviceVersionMajor=$(echo $serviceVersion | rev | cut -d '.' -f2- | rev)
serviceVersionMinor=$(echo $serviceVersion | rev | cut -d '.' -f1 | rev)

serviceVersionMinor=$((serviceVersionMinor+1))

newServiceVersion="$serviceVersionMajor.$serviceVersionMinor"
sed -i -e "s/serviceVersion=.*/serviceVersion=$newServiceVersion/" gradle.properties