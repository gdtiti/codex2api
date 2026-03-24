import { AlertCircle, CheckCircle2 } from 'lucide-react'
import type { ToastState } from '../types'

export default function ToastNotice({ toast }: { toast: ToastState | null }) {
  if (!toast) return null

  const isError = toast.type === 'error'

  return (
    <div
      className={`fixed top-6 right-6 z-[2000] flex max-w-[min(420px,calc(100vw-2rem))] items-start gap-3 rounded-2xl px-4 py-3 text-sm font-semibold text-white shadow-lg max-sm:top-4 max-sm:right-4 ${
        isError ? 'bg-destructive' : 'bg-[hsl(var(--success))]'
      }`}
      style={{ animation: 'toast-slide-in 0.22s ease' }}
      role="status"
      aria-live="polite"
    >
      <span className="mt-0.5 shrink-0">
        {isError ? <AlertCircle className="size-4.5" /> : <CheckCircle2 className="size-4.5" />}
      </span>
      <span className="min-w-0 break-words leading-6">{toast.msg}</span>
    </div>
  )
}
