macro_rules! filter_db {
    ($db:ident, $id:ident, $lang:ident) => {
        $db.filter(
            $id.and_then(|x| x.parse::<i64>().ok()),
            $lang.and_then(|x| Language::from_str(x).ok()),
        )
    };
    (&db:ident, $($lang:ident),*) => {
        let _temp = vec![];
        $(
            for i in db.filter(None, Some(Language::$lang)).iter() {
                _temp.push(i);
            }
        )*;
        _temp
    };
}
