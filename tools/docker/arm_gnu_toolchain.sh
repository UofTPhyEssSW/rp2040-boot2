# Install Linux ARM GNU toolchain 13.2Rel1
# https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads
# ex: https://lindevs.com/install-arm-gnu-toolchain-on-ubuntu
# latest : arm-gnu-toolchain-13.2.rel1-x86_64-arm-none-eabi.tar.xz
# link : https://developer.arm.com/-/media/Files/downloads/gnu/13.2.rel1/binrel/arm-gnu-toolchain-13.2.rel1-x86_64-arm-none-eabi.tar.xz?rev=e434b9ea4afc4ed7998329566b764309&hash=CA590209F5774EE1C96E6450E14A3E26

#1. Get ARM GNU Toolchain latest version (my need to install curl : apt install -y curl)
ARM_TOOLCHAIN_VERSION=$(curl -s https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads | grep -Po '<h4>Version \K.+(?=</h4>)')
ARM_TOOLCHAIN_DLINK=https://developer.arm.com/-/media/Files/downloads/gnu/$ARM_TOOLCHAIN_VERSION/binrel/arm-gnu-toolchain-$ARM_TOOLCHAIN_VERSION-x86_64-arm-none-eabi.tar.xz
#echo $ARM_TOOLCHAIN_VERSION
#echo $ARM_TOOLCHAIN_DLINK
# 2. download latest version
curl -Lo gcc-arm-none-eabi.tar.xz "$ARM_TOOLCHAIN_DLINK"
# 3. make directory un-compress (tar) and store in "/opt/gcc-arm-none-eabi/"
mkdir /opt/gcc-arm-none-eabi
tar xf gcc-arm-none-eabi.tar.xz --strip-components=1 -C /opt/gcc-arm-none-eabi
#4. remove tar file
rm gcc-arm-none-eabi.tar.xz
