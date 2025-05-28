# Ahouefa Ops

# How to split x rays by source

Go into the x-ray directory; You should have the following structure:

```txt
.
├── test
│   ├── NORMAL
│   └── PNEUMONIA
├── train
│   ├── NORMAL
│   └── PNEUMONIA
└── val
    ├── NORMAL
    └── PNEUMONIA
```

Run the following command to split the x-rays by source:

```bash
./split-by-source.sh /absoute/path/to/x-ray/directory
```

You should have the following structure after running the command:

```txt
.
├── test
│   ├── BACTERIA
│   ├── NORMAL
│   └── VIRUS
├── train
│   ├── BACTERIA
│   ├── NORMAL
│   └── VIRUS
└── val
    ├── BACTERIA
    ├── NORMAL
    └── VIRUS
```

And voila! You have successfully split the x-rays by source.
