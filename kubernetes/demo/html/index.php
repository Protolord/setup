<!DOCTYPE html>
<html>
<header>
<title>Welcome!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
code {
  font-family: Consolas,"courier new";
  padding: 2px;
  font-size: 110%;
}
</style>
</header>
<body>

<h1>Welcome to self-hosted web server using PHP and kubernetes</h1>
<p>
This site is being served by:</br>
<code>
<?php
echo file_get_contents("/etc/hostname");
?>
</code>
</p>

</body>
</html>
