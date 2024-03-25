# BASH Script.
# Install Linux ARM GNU toolchain 13.2Rel1
# reference: https://lindevs.com/install-arm-gnu-toolchain-on-ubuntu
#1. Get ARM GNU Toolchain latest version (my need to install curl : apt install -y curl)
echo "Finding latest version of Arm GNU toolchain ..."
ARM_TOOLCHAIN_VERSION=$(curl -s https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads | grep -Po '<h4>Version \K.+(?=</h4>)')
ARM_TOOLCHAIN_DLINK=https://developer.arm.com/-/media/Files/downloads/gnu/$ARM_TOOLCHAIN_VERSION/binrel/arm-gnu-toolchain-$ARM_TOOLCHAIN_VERSION-x86_64-arm-none-eabi.tar.xz
# 2. download latest version
echo "Download Arm GNU toolchain ..."
curl -Lo gcc-arm-none-eabi.tar.xz "$ARM_TOOLCHAIN_DLINK"
# 3. make directory un-compress (tar) and store in "/opt/gcc-arm-none-eabi/"
echo "Extracting and installing Arm GNU toolchain ..."
mkdir /opt/gcc-arm-none-eabi
tar xf gcc-arm-none-eabi.tar.xz --strip-components=1 -C /opt/gcc-arm-none-eabi
#4. remove tar file
echo "Removing tar for Arm GNU toolchain ..."
rm gcc-arm-none-eabi.tar.xz
