package main

type Directory struct {
	Filenames *[]string `json:"filenames"`
	Files     *[][]byte `json:"files"`
}
