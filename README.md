[![Build Status](https://travis-ci.com/asalamon74/knapsack_files.svg?branch=master)](https://travis-ci.com/asalamon74/knapsack_files)
[![CodeFactor](https://www.codefactor.io/repository/github/asalamon74/knapsack_files/badge)](https://www.codefactor.io/repository/github/asalamon74/knapsack_files)

# knapsack_files

Checks the files in a directory and select the the files to be written
onto a DVD to write as many bytes as possible. A simple
[knapsack](https://en.wikipedia.org/wiki/Knapsack_problem)
solver. Only works for small number of files.

##

```
$ ls -ltr /tmp/dir
total 10539888
-rw-r--r-- 1 salamon live 2016854714 May 16  2018 file1.mkv
-rw-r--r-- 1 salamon live 1538666817 Sep  8 08:26 file2.mkv
-rw-r--r-- 1 salamon live 1120814637 Nov 15 08:40 file3.mkv
-rw-r--r-- 1 salamon live 1541202673 Nov 24 17:06 file4.mkv
-rw-r--r-- 1 salamon live 1545390749 Dec 15 12:13 file5.mkv
-rw-r--r-- 1 salamon live 1521317917 Dec 16 13:33 file6.mkv
-rw-r--r-- 1 salamon live 1508551682 Dec 23 08:17 file7.mkv
$ knapsack_files.sh /tmp/dir
4683060100
/tmp/dir/file3.mkv
/tmp/dir/file5.mkv
/tmp/dir/file1.mkv
```

The output can also be piped to `mkisofs`.

```
knapsack_files.sh -o /tmp/dir | xargs mkisofs -iso-level 2 -V label -o dvd.iso
```

### Usage

```
  knapsack_files.sh [options] directory

Options

  -h, --help       display this help
  -d, --debug      print debug messages
  -o, --only_files print only the file names
```
