# commenter.vim

Vim commenter is a vim plugin for automatically commenting a list of languages.

## Prerequisites

* VIM - Vi Improved 8.1+

## Installation

```
$ git clone https://github.com/davidkristoffersen/vim-commenter.git ~/.vim/bundle/vim-commenter
```

## Usage

The main function is `CommenterToggle` and can be run in three ways:

- Using the vim command line

```
: call CommenterToggle()
```

- Using the default leader map

```vim
<leader>ct
```

- Creating a custom leader map

```
$ vim ~/.vimrc
```
```vim
nnoremap <leader>"Your-custom-map" :call CommenterToggle()
```

## Testing

Move to the following directory

```
$ cd ~/.vim/bundle/vim-commenter/testing/
```

Inside `testing` directory is a series of example language files located.  
Open all files and test out the plugin using your configured `leader`.

``sh
$ vim -p *
``

## Authors

* **David Kristoffersen** - *Initial work* - [vim-commenter](https://github.com/davidkristoffersen)

## License

This project is licensed under the GPL License - see the [LICENSE](LICENSE) file for details
