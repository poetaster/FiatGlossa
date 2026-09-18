#ifndef SPELLING_H
#define SPELLING_H

#include <QString>

namespace Spelling {

// target is "EN-GB" (Traditional) or "EN-US" (Simplified).
// Any other target returns the text unchanged.
QString convert(const QString &text, const QString &target);

} // namespace Spelling

#endif // SPELLING_H
