# location of this file /var/www/html/pihole/
<?php $port = '8080';
      header('Location: '
    . ($_SERVER['HTTPS'] ? 'https' : 'http')
    . '://' . $_SERVER['HTTP_HOST'] . ':' . $port  . '/' . 'habpanel' . '/' . 'index.html' . '#'
    . $_SERVER['REQUEST_URI']);
exit;
?>

