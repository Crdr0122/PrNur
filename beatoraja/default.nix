{ stdenv
, unzip
, oraclejre8
, makeWrapper
, openal
,xrandr
}:

let
  pname = "beatoraja-modernchic";
  version = "0.8.7";
  fullName = "beatoraja${version}-modernchic";
  jre = oraclejre8.overrideAttrs {
    src = fetchTarball {
      url = "https://static.sora.zip/nix/jdk-8u281-linux-x64.tar.gz";
      sha256 = "...";
    };
  };
in
stdenv.mkDerivation rec {
  inherit pname version;
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://mocha-repository.info/download/${fullName}.zip";
    sha256 = "..."; # 可以先不填，后面根据报错给的实际值填上
  };
   nativeBuildInputs = [ unzip makeWrapper];
  unpackPhase = "unzip $src"; # $src对应获取到的文件
  preInstall = ''
    rm ${fullName}/beatoraja-config.* # 删除原有的启动脚本
    echo "#!/bin/sh" > ${fullName}/beatoraja.sh # 重新创建启动脚本

    echo 'if [ ! -d "''${XDG_DATA_HOME:-$HOME/.local/share}/beatoraja" ]; then' >> ${fullName}/beatoraja.sh # 如果不存在beatoraja的数据目录

    echo 'mkdir -p "''${XDG_DATA_HOME:-$HOME/.local/share}/beatoraja"'          >> ${fullName}/beatoraja.sh # 创建数据目录
    echo 'cd "''${XDG_DATA_HOME:-$HOME/.local/share}/beatoraja"'                >> ${fullName}/beatoraja.sh # 进入数据目录
echo "exec ${jre}/bin/java -Xms1g -Xmx4g -jar '$out/share/beatoraja/beatoraja.jar'" >> ${fullName}/beatoraja.sh
    # 复制相关文件
    echo "cp -r $out/share/beatoraja/bgm ./"          >> ${fullName}/beatoraja.sh
    echo "cp -r $out/share/beatoraja/defaultsound ./" >> ${fullName}/beatoraja.sh
    echo "cp -r $out/share/beatoraja/folder ./"       >> ${fullName}/beatoraja.sh
    echo "cp -r $out/share/beatoraja/ir ./"           >> ${fullName}/beatoraja.sh
    echo "cp -r $out/share/beatoraja/skin ./"         >> ${fullName}/beatoraja.sh
    echo "cp -r $out/share/beatoraja/sound ./"        >> ${fullName}/beatoraja.sh
    echo "cp -r $out/share/beatoraja/table ./"        >> ${fullName}/beatoraja.sh

    # 修改权限
    echo "find . -type d -exec chmod 755 {} \;"       >> ${fullName}/beatoraja.sh
    echo "find . -type f -exec chmod 644 {} \;"       >> ${fullName}/beatoraja.sh

    echo "fi" >> ${fullName}/beatoraja.sh

    echo 'cd "''${XDG_DATA_HOME:-$HOME/.local/share}/beatoraja"' >> ${fullName}/beatoraja.sh # 确保每次执行的工作目录

# 这里通过内联oraclejre8能够直接获取到其在/nix/store中的路径
    echo "exec ${oraclejre8}/bin/java -Xms1g -Xmx4g -jar '$out/share/beatoraja/beatoraja.jar'" >> ${fullName}/beatoraja.sh
    chmod +x ${fullName}/beatoraja.sh # 赋予执行权限
    '';
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/beatoraja
    mkdir -p $out/bin
    mv ${fullName}/beatoraja.sh $out/bin/beatoraja
    mv ${fullName}/* $out/share/beatoraja

# prefix: 在原有的环境变量前添加

wrapProgram $out/bin/beatoraja \
--prefix _JAVA_OPTIONS : "-Dsun.java2d.opengl=true -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
--prefix LD_LIBRARY_PATH : "${openal}/lib" \
--prefix LD_PRELOAD : "${openal}/lib/libopenal.so" \
--prefix PATH : "${xrandr}/bin" \

runHook postInstall
'';
}

