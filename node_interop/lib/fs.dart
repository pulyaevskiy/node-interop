// Copyright (c) 2017, Anatoly Pulyaevskiy. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'src/cjs/require.dart';
import 'src/fs/module.dart';

export 'src/fs/big_int_file_system_stats.dart';
export 'src/fs/big_int_stats.dart';
export 'src/fs/dir.dart';
export 'src/fs/dir_entry.dart';
export 'src/fs/file_handle.dart';
export 'src/fs/file_system_stats.dart';
export 'src/fs/module.dart'
    hide
        AppendFileOptions,
        CopyRecursiveOptions,
        GlobOptions,
        StatOptions,
        MakeDirOptions,
        OpenDirOptions,
        ReadDirOptions,
        ReadFileOptions,
        ReadWriteOptions,
        ReadResult,
        RemoveDirOptions,
        RemoveOptions,
        WatchOptions,
        WriteFileOptions,
        WriteResult;
export 'src/fs/read_stream.dart';
export 'src/fs/stats.dart';
export 'src/fs/write_stream.dart';

/// The Node.js [file system module].
///
/// [file system module]: https://nodejs.org/docs/latest/api/fs.html
final FSModule fs = require('fs');
